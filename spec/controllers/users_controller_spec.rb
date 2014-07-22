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
      context 'successful user sign up' do
        let(:user) { Fabricate.attributes_for(:user) }
        before do
          result = double(:sign_up_result, successful?: true)
          expect_any_instance_of(UserManager).to receive(:sign_up).and_return(result)
          post :create, user: user, stripeToken: '1234567'
        end

        it 'redirect to home path' do
          expect(response).to redirect_to home_path
        end

        # it 'auto login user' do
        #   expect(session[:user_id]).to eq(User.first.id)
        # end
      end

      context 'failed user sign up' do
        before do
          result = double(:sign_up_result, successful?: false, error_message: 'The error message.')
          expect_any_instance_of(UserManager).to receive(:sign_up).and_return(result)
        end

        it 'renders new template' do
          post :create, user: Fabricate.attributes_for(:user), stripeToken: '1234567'
          expect(response).to render_template :new
        end

        it 'sets flash error message' do
          post :create, user: Fabricate.attributes_for(:user), stripeToken: '1234567'
          expect(flash[:danger]).to eq('The error message.')
        end

        it 'sets @user variable' do
          user = Fabricate.attributes_for(:user)
          post :create, user: user, stripeToken: '1234567', invitation_token: '123456'
          expect(assigns(:user)).to be_instance_of(User)
        end

        it 'sets @invitation_token variable when user is invitation by friend' do
          post :create, user: Fabricate.attributes_for(:user), stripeToken: '1234567', invitation_token: '123456'
          expect(assigns(:invitation_token)).to eq('123456')
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