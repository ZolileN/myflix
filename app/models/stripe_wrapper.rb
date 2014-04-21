module StripeWrapper
  class Charge
    attr_reader :error_message, :response
    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options={})
      begin
        response = Stripe::Charge.create(
          amount: options[:amount],
          currency: 'usd',
          card: options[:card],
          description: options[:description]
          )
        new(response: response)
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end

    def successful?
      response.present?
    end
  end

  class Customer
    attr_reader :response, :error_message, :customer_token

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
      @customer_token = options[:customer_token]
    end

    def self.create(options={})
      begin
        response = Stripe::Customer.create(
          email: options[:user].email,
          plan: "base",
          card: options[:card]
          )
        new(response: response, customer_token: response.id)
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end

    def successful?
      response.present?
    end
  end
end