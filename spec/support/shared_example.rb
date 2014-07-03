shared_examples 'require_sign_in' do
  it 'redirect to root_path' do
    clean_current_user
    action
    expect(response).to redirect_to root_path
  end
end