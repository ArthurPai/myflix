require 'spec_helper'

describe 'UserManager' do
  before { ActionMailer::Base.deliveries.clear }
  after { ActionMailer::Base.deliveries.clear }

  context 'with personal info and valid credit card' do
    let(:fiona) { Fabricate.build(:user, email: 'fiona@intxtion.com', full_name: 'Fiona Cheng') }
    before do
      customer = double('customer', successfully?: true, id: '4321')
      expect(StripeWrapper::Customer).to receive(:create).and_return(customer)
    end

    it 'creates user' do
      UserManager.new(fiona).sign_up('stripe_token', nil)
      expect(User.count).to eq(1)
    end

    it 'saves stripe customer id to user' do
      UserManager.new(fiona).sign_up('stripe_token', nil)
      expect(User.first.stripe_customer_id).to eq('4321')
    end

    context 'email sending' do
      it 'send out the email to the user when valid input' do
        UserManager.new(fiona).sign_up('stripe_token', nil)
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it 'sends to the right recipient to the user when valid input' do
        UserManager.new(fiona).sign_up('stripe_token', nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(['fiona@intxtion.com'])
      end

      it 'has the right content to the user when valid input' do
        UserManager.new(fiona).sign_up('stripe_token', nil)
        expect(ActionMailer::Base.deliveries.last.body).to include('Fiona Cheng')
      end
    end

    context 'when user is invitation by friend' do
      let!(:john) { Fabricate(:user, full_name: 'john doe', email: 'john@example.com') }
      before do
        john.update_column(:invitation_token, '123456')
      end

      context 'with valid invitation' do
        it 'makes the user following inviter' do
          UserManager.new(fiona).sign_up('stripe_token', '123456')
          expect(john.reload.followers).to eq([User.last])
        end

        it 'makes inviter following the user' do
          UserManager.new(fiona).sign_up('stripe_token', '123456')
          expect(User.last.followers).to eq([john])
        end
      end

      context 'with invalid invitation' do
        it 'does not make the user following inviter' do
          UserManager.new(fiona).sign_up('stripe_token', nil)
          expect(john.reload.followers).not_to include(User.last)
        end

        it 'does not make inviter following the user' do
          UserManager.new(fiona).sign_up('stripe_token', nil)
          expect(User.last.followers).not_to include(john)
        end
      end
    end
  end

  context 'with invalid personal info' do
    let(:user) { Fabricate.build(:user, email: '') }

    it 'does not create user' do
      UserManager.new(user).sign_up('stripe_token', nil)
      expect(User.count).to eq(0)
    end

    it 'does not send out the email' do
      UserManager.new(user).sign_up('stripe_token', nil)
      expect(ActionMailer::Base.deliveries).to be_empty
    end

    it 'does not create subscription plane to the card' do
      expect(StripeWrapper::Customer).not_to receive(:create)
      UserManager.new(user).sign_up('stripe_token', nil)
    end
  end

  context 'with valid personal info and a declined card' do
    let(:user) { Fabricate.build(:user) }
    before do
      customer = double('customer', successfully?: false, error_message: 'Your card was declined.' )
      expect(StripeWrapper::Customer).to receive(:create).and_return(customer)
    end

    it 'does not create user' do
      UserManager.new(user).sign_up('stripe_token', nil)
      expect(User.count).to eq(0)
    end

    it 'does not send out the email' do
      UserManager.new(user).sign_up('stripe_token', nil)
      expect(ActionMailer::Base.deliveries).to be_empty
    end
  end
end