require 'spec_helper'

describe StripeWrapper do
  let(:valid_token) do
    Stripe::Token.create(
      :card => {
        :number => "4242424242424242",
        :exp_month => 4,
        :exp_year => 2019,
        :cvc => "314"
      },
    ).id
  end

  let(:declined_token) do
    Stripe::Token.create(
      :card => {
        :number => "4000000000000002",
        :exp_month => 4,
        :exp_year => 2019,
        :cvc => "314"
      },
    ).id
  end
  describe StripeWrapper::Charge do
    describe ".create" do
      it "makes a successful charge", :vcr do
          response = StripeWrapper::Charge.create(
          amount: 400,
          card: valid_token, 
          description: "Valid Charge"
          )
        expect(response).to be_successful
      end

      it "makes a declined card charge", :vcr do
        response = StripeWrapper::Charge.create(
          amount: 400,
          card: declined_token, 
          description: "Invalid Charge"
          )
        expect(response).not_to be_successful
      end

      it "returns the error message for declined charges", :vcr do
        response = StripeWrapper::Charge.create(
          amount: 400,
          card: declined_token, 
          description: "Invalid Charge"
          )
        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".create" do
      it "creates a customer with valid card", :vcr do
        user = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: user,
          card: valid_token
          )
        expect(response).to be_successful
      end

      it "does not create a customer with declined card", :vcr do
        user = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: user,
          card: declined_token
          )
        expect(response).not_to be_successful
      end

      it "returns the error message for declined charges", :vcr do
        user = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: user,
          card: declined_token
          )
        expect(response.error_message).to eq("Your card was declined.")
      end
      it "returns the customer token for a valid card", :vcr do
        user = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: user,
          card: valid_token
          )
        expect(response.customer_token).to be_present
      end
    end
  end
end