shared_examples 'require sign in' do
  it 'redirects to root_path' do
    clean_current_user
    action
    expect(response).to redirect_to root_path
  end
end

shared_examples 'require admin' do
  before do
    set_current_user
    action
  end

  it { expect(response).to redirect_to home_path }
  it { expect(flash[:danger]).not_to be_blank }
end

shared_examples 'tokenable' do
  it 'generates a token when created' do
    expect(object.send(object.class.token_column.to_sym)).to be_present
  end
end