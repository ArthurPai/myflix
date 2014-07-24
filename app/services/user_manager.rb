class UserManager
  attr_accessor :status, :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invitation_token)
    if @user.valid?
      customer = StripeWrapper::Customer.create(plane: 'Basic', card: stripe_token, description: "Sign up charge from #{@user.email}")

      if customer.successfully?
        @user.stripe_customer_id = customer.id
        @user.save
        UserMailer.delay.welcome_email(@user)
        handle_invitation(invitation_token)
        @status = :success
      else
        @status = :failed
        @error_message = customer.error_message
      end
    else
      @status = :failed
      @error_message = 'Invalid user information. Please check the errors below.'
    end

    self
  end

  def successful?
    @status == :success
  end

  private

  def handle_invitation(invitation_token)
    inviter = User.find_by_invitation_token(invitation_token)
    if inviter
      inviter.followers << @user
      @user.followers << inviter
    end
  end
end