require 'spec_helper'

describe ResetPasswordController do
  describe 'GET new' do
    let!(:john) { Fabricate(:user, email: 'john@intxtion.com', password: 'password', reset_password_token: SecureRandom.urlsafe_base64) }
    let!(:jane) { Fabricate(:user, email: 'jane@intxtion.com', password: 'password', reset_password_token: nil) }

    it 'redirects to invalid token page if reset password token is nil' do
      get :new
      expect(response).to redirect_to invalid_token_path
    end

    it 'redirects to invalid token page if reset password token is invalid' do
      get :new, reset_token: 'wrong password'
      expect(response).to redirect_to invalid_token_path
    end

    it 'sets @reset_token variable if reset password token is valid' do
      get :new, reset_token: john.reset_password_token
      expect(assigns(:reset_token)).to eq(john.reset_password_token)
    end

    it 'render new template if reset password token is valid' do
      get :new, reset_token: john.reset_password_token
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do
    let!(:john) { Fabricate(:user, email: 'john@intxtion.com', password: 'password', reset_password_token: SecureRandom.urlsafe_base64) }
    let!(:jane) { Fabricate(:user, email: 'jane@intxtion.com', password: 'password', reset_password_token: nil) }

    context 'with valid password' do
      it 'redirect to sign in page' do
        post :create, reset_token: john.reset_password_token, password: 'newpassword'
        expect(response).to redirect_to login_path
      end

      it 'changes password' do
        old_password = john.password_digest
        post :create, reset_token: john.reset_password_token, password: 'newpassword'
        expect(john.reload.password_digest).not_to eq(old_password)
      end

      it 'removes the reset password token' do
        post :create, reset_token: john.reset_password_token, password: 'newpassword'
        expect(john.reload.reset_password_token).to be_nil
      end
    end

    it 'redirects to invalid token page if reset password token is invalid' do
      post :create, reset_token: SecureRandom.urlsafe_base64, password: 'newpassword'
      expect(response).to redirect_to invalid_token_path
    end

    it 'redirects to invalid token page if reset password token is nil' do
      post :create, password: 'newpassword'
      expect(response).to redirect_to invalid_token_path
    end

    it 'redirects to reset password path when user submit invalid password' do
      post :create, reset_token: john.reset_password_token, password: 'new'
      expect(response).to redirect_to reset_password_path
    end
  end
end