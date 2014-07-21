require 'spec_helper'

describe ForgotPasswordController do
  describe 'GET new' do
    it 'redirects to the home path if user is sing in' do
      set_current_user
      get :new, email: 'any@example.com'
      expect(response).to redirect_to home_path
    end
  end

  describe 'GET confirm' do
    it 'redirects to the home path if user is sing in' do
      set_current_user
      get :confirm, email: 'any@example.com'
      expect(response).to redirect_to home_path
    end
  end

  describe 'POST create' do
    before { ActionMailer::Base.deliveries.clear }
    after { ActionMailer::Base.deliveries.clear }

    context 'with correct email of exist user' do
      let!(:john) { Fabricate(:user, email:'john@intxtion.com')}
      before { post :create, email: john.email }

      it 'redirects to the confirm password reset page' do
        expect(response).to redirect_to confirm_password_reset_path
      end

      it 'send out rest password email to the user' do
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it 'sends to the right recipient' do
        letter = ActionMailer::Base.deliveries.last
        expect(letter.to).to eq([john.email])
      end

      it 'had reset password token in the sending email' do
        # reset_url = reset_password_url(reset_token: john.reload.reset_password_token)
        letter = ActionMailer::Base.deliveries.last
        expect(letter.body).to have_content(john.reload.reset_password_token)
      end
    end

    context 'with blank input' do
      before { post :create, email: '' }

      it 'redirects to the forgot password path' do
        expect(response).to redirect_to forgot_password_path
      end

      it 'displays error flash message' do
        expect(flash[:danger]).not_to be_blank
      end

      it 'does not send out reset password email' do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context 'with non-exist user email' do
      before { post :create, email: 'unknown@example.com' }

      it 'redirects to the forgot password path' do
        expect(response).to redirect_to forgot_password_path
      end

      it 'displays error flash message' do
        expect(flash[:danger]).not_to be_blank
      end

      it 'does not send out reset password email' do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    it 'redirects to the home path if user is sing in' do
      set_current_user
      post :create, email: 'any@example.com'
      expect(response).to redirect_to home_path
    end
  end
end