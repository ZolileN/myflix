require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      it "makes a successful charge", :vcr do
        StripeWrapper.set_api_key 
        token = Stripe::Token.create(
          :card => {
            :number => "4242424242424242",
            :exp_month => 4,
            :exp_year => 2019,
            :cvc => "314"
          },
        ).id

        response = StripeWrapper::Charge.create(
          amount: 400,
          card: token, 
          description: "Valid Charge"
          )

        expect(response.amount).to eq(400)
        expect(response.currency).to eq('usd')

      end
    end
  end
end