require 'spec_helper'

describe UsersController do

  context 'with unauthenticated user' do
    describe 'GET new' do
      it 'sets @user variable' do
        get :new
        expect(assigns(:user)).to be_instance_of(User)
      end
    end

    describe 'POST create' do
      context 'with valid input' do
        let(:user) { Fabricate.attributes_for(:user) }
        before { post :create, user: user }

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

      context 'with invalid input' do
        before { post :create, user: {email: ''} }
        it 'does not saves user in database' do
          expect(User.count).to eq(0)
        end

        it 'render again new template' do
          expect(response).to render_template :new
        end

        it 'sets @user variable' do
          expect(assigns(:user)).to be_instance_of(User)
        end
      end

      context 'email sending' do
        after { ActionMailer::Base.deliveries.clear }
        let(:fiona) { Fabricate.attributes_for(:user, email: 'fiona@intxtion.com', full_name: 'Fiona Cheng') }

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