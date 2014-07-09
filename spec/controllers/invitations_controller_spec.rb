require 'spec_helper'

describe InvitationsController do

  describe 'POST create' do
    before do
      set_current_user
      current_user.update_column(:invitation_token, '123456')
    end

    it_behaves_like 'require sign in' do
      let(:action) { post :create, name: 'any', email: 'any@example', message: 'any' }
    end

    context 'with valid input' do
      before do
        post :create, name: 'jane', email: 'jane@example.com', message: 'Join this site!\nJane Come Here.'
      end
      after { ActionMailer::Base.deliveries.clear }

      it 'redirects to invite friend page' do
        expect(response).to redirect_to invite_path
      end

      it 'send out the invitation mail to the friend' do
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it 'send to the right recipient' do
        letter = ActionMailer::Base.deliveries.last
        expect(letter.to).to eq(['jane@example.com'])
      end

      it 'has the user message in the sending email' do
        letter = ActionMailer::Base.deliveries.last
        expect(letter.body).to have_content('Join this site!\nJane Come Here.')
      end

      it 'sets flash success message' do
        expect(flash[:success]).not_to be_blank
      end
    end

    context 'with invalid input' do
      shared_examples 'not send invitation' do
        it 'does not send invitation mail' do
          expect(ActionMailer::Base.deliveries).to be_empty
        end

        it 'renders new template' do
          expect(response).to render_template :new
        end

        it 'sets flash error message' do
          expect(flash[:danger]).not_to be_blank
        end
      end

      context "that friend's name is nil" do
        before { post :create, email: 'jane@example.com', message: 'Join this site!\nJane Come Here.' }

        it_behaves_like 'not send invitation'
      end

      context "that friend's name is blank" do
        before { post :create, name: '', email: 'jane@example.com', message: 'Join this site!\nJane Come Here.' }

        it_behaves_like 'not send invitation'
      end

      context "that friend's email is blank" do
        before { post :create, name: 'jane', message: 'Join this site!\nJane Come Here.' }

        it_behaves_like 'not send invitation'
      end

      context "that friend's email is blank" do
        before { post :create, name: 'jane', email: '', message: 'Join this site!\nJane Come Here.' }

        it_behaves_like 'not send invitation'
      end
    end
  end
end