require 'spec_helper'

describe FellowshipsController do
  describe 'GET index' do
    it_behaves_like 'require sign in' do
      let(:action) { get :index }
    end
  end
end