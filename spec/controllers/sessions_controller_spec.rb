require 'spec_helper'

describe SessionsController do
  let(:user) { Fabricate(:user) }

  context 'with unauthenticated user' do
    describe 'GET new' do
      it 'render new template' do
        get :new
        expect(response).to render_template :new
      end
    end

    describe 'POST create' do
      context 'with valid credentials' do
        before { post :create, {email: user.email, password: user.password} }

        it 'put sign in user in the session' do
          # expect(controller).to be_logged_in
          expect(session[:user_id]).to eq(user.id)
        end

        it 'will redirect to home path' do
          expect(response).to redirect_to home_path
        end

        it 'set the success flash' do
          expect(flash[:success]).not_to be_blank
        end
      end

      context 'with invalid credentials' do
        before { post :create, {email: user.email, password: ''} }

        it 'does not put user in the session' do
          expect(session[:user_id]).to be_nil
        end

        it 'will render again new template' do
          expect(response).to render_template(:new)
        end

        it 'sets the danger flash' do
          expect(flash[:danger]).not_to be_blank
        end
      end
    end

    describe 'GET destroy' do
      it 'will redirect to root path' do
        get :destroy
        expect(response).to redirect_to root_path
      end
    end
  end

  context 'with authenticated user' do
    before { login user }

    describe 'GET new' do
      before { get :new }

      it 'will redirect to root path' do
        expect(response).to redirect_to home_path
      end

      it 'sets info flash' do
        expect(flash[:info]).not_to be_blank
      end
    end

    describe 'POST create' do
      before { post :create, {email: user.email, password: user.password} }

      it 'will redirect to root path' do
        expect(response).to redirect_to home_path
      end

      it 'sets info flash' do
        expect(flash[:info]).not_to be_blank
      end
    end

    describe 'GET destroy' do
      before { get :destroy }

      it 'will sign out user' do
        # expect(controller).not_to be_logged_in
        expect(session[:user_id]).to be_nil
      end

      it 'redirect to root path' do
        expect(response).to redirect_to root_path
      end

      it 'sets success flash' do
        expect(flash[:success]).not_to be_blank
      end
    end
  end
end