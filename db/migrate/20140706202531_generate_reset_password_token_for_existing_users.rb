class GenerateResetPasswordTokenForExistingUsers < ActiveRecord::Migration
  def change
    User.all.each do |user|
      user.generate_reset_password_token
    end
  end
end
