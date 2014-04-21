require 'spec_helper'

describe "Deactivate user on failed payment", :vcr do
  let(:event_data) do
    {
      "id"=> "evt_103tXX20rukLV0WotMALXKn7",
      "created"=> 1398098402,
      "livemode"=> false,
      "type"=> "charge.failed",
      "data"=> {
        "object"=> {
          "id"=> "ch_103tXX20rukLV0WoKZEreFTY",
          "object"=> "charge",
          "created"=> 1398098402,
          "livemode"=> false,
          "paid"=> false,
          "amount"=> 999,
          "currency"=> "usd",
          "refunded"=> false,
          "card"=> {
            "id"=> "card_103tXW20rukLV0Woz2SKHmqo",
            "object"=> "card",
            "last4"=> "0341",
            "type"=> "Visa",
            "exp_month"=> 11,
            "exp_year"=> 2017,
            "fingerprint"=> "eChiXDEYqx2oUxEY",
            "customer"=> "cus_3tWedhwdFz3Q0U",
            "country"=> "US",
            "name"=> nil,
            "address_line1"=> nil,
            "address_line2"=> nil,
            "address_city"=> nil,
            "address_state"=> nil,
            "address_zip"=> nil,
            "address_country"=> nil,
            "cvc_check"=> "pass",
            "address_line1_check"=> nil,
            "address_zip_check"=> nil
          },
          "captured"=> false,
          "refunds"=> [],
          "balance_transaction"=> nil,
          "failure_message"=> "Your card was declined.",
          "failure_code"=> "card_declined",
          "amount_refunded"=> 0,
          "customer"=> "cus_3tWedhwdFz3Q0U",
          "invoice"=> nil,
          "description"=> "testing failed payment",
          "dispute"=> nil,
          "metadata"=> {},
          "statement_description"=> nil
        }
      },
      "object"=> "event",
      "pending_webhooks"=> 1,
      "request"=> "iar_3tXXaueD5TeH4U"
    }
  end

  it "deactivates the user associated with the event_data" do
    user = Fabricate(:user, customer_token: "cus_3tWedhwdFz3Q0U")
    post "/stripe_events", event_data
    expect(User.first).not_to be_active
  end
end