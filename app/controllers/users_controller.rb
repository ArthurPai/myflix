class UsersController < ApplicationController
  before_action :require_login, only: [:show]
  before_action :require_not_login, only: [:new, :create]

  def new
    @user = User.new

    inviter = User.find_by_invitation_token(params[:invitation_token])
    if inviter
      @user.email = params[:email]
      @invitation_token = inviter.invitation_token
    end
  end

  def create
    @user = User.new(user_params)
    @invitation_token = params[:invitation_token]

    if @user.valid?
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      token = params[:stripeToken]

      begin
        charge = Stripe::Charge.create(
            :amount => 999,
            :currency => 'usd',
            :card => token,
            :description => "Sign up charge from #{@user.email}"
        )
        @user.save
        flash[:success] = 'Register Succeed.'
        UserMailer.delay.welcome_email(@user)
        handle_invitation
        sign_in @user
        redirect_to home_path
      rescue Stripe::CardError => e
        flash[:danger] = e.message
        render :new
      end
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :full_name)
    end

    def handle_invitation
      inviter = User.find_by_invitation_token(params[:invitation_token])
      if inviter
        inviter.followers << @user
        @user.followers << inviter
      end
    end
end