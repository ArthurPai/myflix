class GenerateInvitationTokeForExistingUsers < ActiveRecord::Migration
  def change
    User.all.each do |user|
      user.generate_invitation_token
    end
  end
end
