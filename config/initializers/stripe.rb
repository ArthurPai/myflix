Stripe.api_key = ENV['STRIPE_SECRET_KEY']

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    user = User.find_by_stripe_customer_id(event.data.object.customer)
    Payment.create(user: user, reference_id: event.data.object.id, amount: event.data.object.amount)
  end
end
