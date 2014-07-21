require 'spec_helper'

describe UsersController do

  context 'with unauthenticated user' do
    describe 'GET new' do
      it 'sets @user variable' do
        get :new
        expect(assigns(:user)).to be_instance_of(User)
      end

      context 'when user is invitation by friend' do
        let!(:john) { Fabricate(:user, full_name: 'john doe', email: 'john@example.com') }
        before do
          john.update_column(:invitation_token, '123456')
        end

        context 'with valid invitation' do
          before { get :new, invitation_token: '123456', email: 'jane@example.com' }

          it 'sets email to @user variable' do
            expect(assigns(:user).email).to eq('jane@example.com')
          end

          it 'sets @invitation_token variable' do
            expect(assigns(:invitation_token)).to eq('123456')
          end
        end

        context 'with invalid invitation' do
          before { get :new, invitation_token: '1234', email: 'jane@example.com' }

          it 'does not set email to @user variable' do
            expect(assigns(:user).email).to be_nil
          end

          it 'does not set @invitation_token variable' do
            expect(assigns(:invitation_token)).to be_nil
          end
        end
      end
    end

    describe 'POST create' do
      before { ActionMailer::Base.deliveries.clear }

      context 'with valid personal info and a declined card' do
        let(:user) { Fabricate.attributes_for(:user) }
        before do
          charge = double('charge')
          allow(charge).to receive(:successfully?).and_return(false)
          allow(charge).to receive(:error_message).and_return('Your card was declined.')
          expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
          post :create, user: user, stripeToken: '1234567'
        end
        after { ActionMailer::Base.deliveries.clear }

        it 'does not save user in database' do
          expect(User.count).to eq(0)
        end

        it 'render again new template' do
          expect(response).to render_template :new
        end

        it 'sets flash error message' do
          expect(flash[:danger]).to eq('Your card was declined.')
        end
      end

      context 'with personal info and valid credit card' do
        let(:user) { Fabricate.attributes_for(:user) }
        before do
          charge = double('charge')
          allow(charge).to receive(:successfully?).and_return(true)
          expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
          post :create, user: user
        end
        after { ActionMailer::Base.deliveries.clear }

        it 'saves user in database' do
          expect(User.count).to eq(1)
        end

        it 'redirect to home path' do
          expect(response).to redirect_to home_path
        end

        it 'auto login user' do
          # expect(controller.current_user).to eq(User.find_by(email: user['email']))
          expect(session[:user_id]).to eq(User.find_by(email: user['email']).id)
        end
      end

      context 'when user is invitation by friend' do
        let!(:john) { Fabricate(:user, full_name: 'john doe', email: 'john@example.com') }
        before do
          charge = double('charge')
          allow(charge).to receive(:successfully?).and_return(true)
          allow(StripeWrapper::Charge).to receive(:create).and_return(charge)
          john.update_column(:invitation_token, '123456')
        end
        after { ActionMailer::Base.deliveries.clear }

        context 'with valid invitation' do
          context 'and valid input' do
            let!(:jane) { Fabricate.attributes_for(:user) }
            before { post :create, user: jane, invitation_token: '123456' }

            it 'makes the user following inviter' do
              expect(john.reload.followers).to eq([User.last])
            end

            it 'makes inviter following the user' do
              expect(User.last.followers).to eq([john])
            end
          end

          context 'but invalid input' do
            let!(:jane) { Fabricate.attributes_for(:user, email: '') }
            before { post :create, user: jane, invitation_token: '123456' }

            it 'sets @invitation_token variable' do
              expect(assigns(:invitation_token)).to eq('123456')
            end
          end
        end

        context 'with invalid invitation' do
          let!(:jane) { Fabricate.attributes_for(:user) }
          before { post :create, user: jane, invitation_token: '1234' }

          it 'does not make the user following inviter' do
            expect(john.reload.followers).not_to include(User.last)
          end

          it 'does not make inviter following the user' do
            expect(User.last.followers).not_to include(john)
          end
        end
      end

      context 'with invalid personal info' do
        it 'does not saves user in database' do
          post :create, user: {email: ''}
          expect(User.count).to eq(0)
        end

        it 'render again new template' do
          post :create, user: {email: ''}
          expect(response).to render_template :new
        end

        it 'sets @user variable' do
          post :create, user: {email: ''}
          expect(assigns(:user)).to be_instance_of(User)
        end

        it 'does not charge the card' do
          expect(StripeWrapper::Charge).not_to receive(:create)
          post :create, user: {email: ''}
        end
      end

      context 'email sending' do
        let(:fiona) { Fabricate.attributes_for(:user, email: 'fiona@intxtion.com', full_name: 'Fiona Cheng') }
        before do
          charge = double('charge')
          allow(charge).to receive(:successfully?).and_return(true)
          allow(StripeWrapper::Charge).to receive(:create).and_return(charge)
        end
        after { ActionMailer::Base.deliveries.clear }

        it 'send out the email to the user when valid input' do
          post :create, user: fiona
          expect(ActionMailer::Base.deliveries).not_to be_empty
        end

        it 'sends to the right recipient to the user when valid input' do
          post :create, user: fiona
          letter = ActionMailer::Base.deliveries.last
          expect(letter.to).to eq(['fiona@intxtion.com'])
        end

        it 'has the right content to the user when valid input' do
          web_site_name = 'Arthur Flex'

          post :create, user: fiona
          letter = ActionMailer::Base.deliveries.last
          expect(letter.body).to include(web_site_name)
          expect(letter.body).to include('Fiona Cheng')
        end

        it 'does not send out the email when invalid input' do
          post :create, user: {email: ''}
          expect(ActionMailer::Base.deliveries).to be_empty
        end
      end
    end
  end

  context 'with authenticated user' do
    before { set_current_user }

    describe 'GET new' do
      it 'redirect to home path' do
        get :new
        expect(response).to redirect_to home_path
      end
    end

    describe 'POST create' do
      it 'redirect to home path' do
        post :create, user: {email: ''}
        expect(response).to redirect_to home_path
      end
    end
  end

  describe 'GET show' do
    before { set_current_user }

    it 'sets @user variable' do
      mia = Fabricate(:user)
      get :show, id: mia.id
      expect(assigns(:user)).to eq(mia)
    end

    it_behaves_like 'require sign in' do
      let(:action) { get :show, id: 1 }
    end
  end
end