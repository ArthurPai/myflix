shared_examples 'require sign in' do
  it 'redirects to root_path' do
    clean_current_user
    action
    expect(response).to redirect_to root_path
  end
end