Stripe.api_key = ENV['STRIPE_SECRET_KEY']

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    data = event.data.object
    user = User.where(customer_token: data.customer).first
    amount = data.amount
    reference_id = data.id
    Payment.create(user: user, amount: amount, reference_id: reference_id)
  end
end