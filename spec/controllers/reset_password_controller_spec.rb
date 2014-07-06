require 'spec_helper'

describe ResetPasswordController do
  describe 'GET new' do
    let!(:john) { Fabricate(:user, email: 'john@intxtion.com', password: 'password') }
    before do
      john.update_column(:reset_password_token, '123456')
    end

    it 'redirects to invalid token page if reset password token is nil' do
      get :new
      expect(response).to redirect_to invalid_token_path
    end

    it 'redirects to invalid token page if reset password token is blank' do
      get :new, reset_token: ''
      expect(response).to redirect_to invalid_token_path
    end

    it 'redirects to invalid token page if reset password token is invalid' do
      get :new, reset_token: 'wrong token'
      expect(response).to redirect_to invalid_token_path
    end

    context 'with valid reset password token' do
      before { get :new, reset_token: '123456' }

      it 'sets @reset_token variable' do
        expect(assigns(:reset_token)).to eq('123456')
      end

      it 'render new template' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST create' do
    let!(:john) { Fabricate(:user, email: 'john@intxtion.com', password: 'password') }
    before do
      john.update_column(:reset_password_token, '123456')
    end

    context 'with valid password' do
      before { post :create, reset_token: '123456', password: 'new_password' }

      it 'redirect to sign in page' do
        expect(response).to redirect_to login_path
      end

      it "changes the user's password" do
        expect(john.reload.authenticate('new_password')).to be_truthy
      end

      it 'sets the success flash message' do
        expect(flash[:success]).not_to be_blank
      end

      it 're-generates the reset password token' do
        expect(john.reload.reset_password_token).not_to eq('123456')
      end
    end

    it 'redirects to invalid token page if reset password token is expire' do
      post :create, reset_token: '1234', password: 'new_password'
      expect(response).to redirect_to invalid_token_path
    end

    it 'redirects to invalid token page if reset password token is nil' do
      post :create, password: 'new_password'
      expect(response).to redirect_to invalid_token_path
    end

    context 'with invalid password' do
      before { post :create, reset_token: '123456', password: 'new' }

      it 'redirects to reset password path when user submit ' do
        expect(response).to redirect_to reset_password_path(reset_token: '123456')
      end

      it 'sets warning flash message' do
        expect(flash[:warning]).not_to be_blank
      end
    end

    context 'with blank password' do
      before { post :create, reset_token: '123456', password: '' }

      it 'redirects to reset password path' do
        expect(response).to redirect_to reset_password_path(reset_token: '123456')
      end

      it 'sets warning flash message' do
        expect(flash[:warning]).not_to be_blank
      end
    end
  end
end