require 'spec_helper'

describe Admin::PaymentsController do
  describe 'GET index' do
    it_behaves_like 'require sign in' do
      let(:action) { get :index }
    end

    it_behaves_like 'require admin' do
      let(:action) { get :index }
    end

    context 'administrator' do
      before do
        set_current_admin
      end

      it 'sets @payments' do
        payment1 = Fabricate(:payment)
        payment2 = Fabricate(:payment)
        get :index
        expect(assigns(:payments)).to eq([payment1, payment2])
      end
    end
  end
end