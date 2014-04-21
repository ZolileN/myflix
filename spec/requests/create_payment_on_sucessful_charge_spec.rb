require 'spec_helper'

describe "Create payment on successul charge", :vcr do
  let(:event_data) do 
    {
        "id"=> "evt_103tVW20rukLV0WoS6Pv3sxt",
        "created"=> 1398090873,
        "livemode"=> false,
        "type"=> "charge.succeeded",
        "data"=> {
          "object"=> {
            "id"=> "ch_103tVW20rukLV0Woy8rZdBdn",
            "object"=> "charge",
            "created"=> 1398090872,
            "livemode"=> false,
            "paid"=> true,
            "amount"=> 999,
            "currency"=> "usd",
            "refunded"=> false,
            "card"=> {
              "id"=> "card_103tVW20rukLV0Woo85LL0ps",
              "object"=> "card",
              "last4"=> "4242",
              "type"=> "Visa",
              "exp_month"=> 9,
              "exp_year"=> 2017,
              "fingerprint"=> "YDswDJ57KdtFpKMt",
              "customer"=> "cus_3tVWkvqzmpjSDY",
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
            "captured"=> true,
            "refunds"=> [],
            "balance_transaction"=> "txn_103tVW20rukLV0WoHTul4XfT",
            "failure_message"=> nil,
            "failure_code"=> nil,
            "amount_refunded"=> 0,
            "customer"=> "cus_3tVWkvqzmpjSDY",
            "invoice"=> "in_103tVW20rukLV0WozN3MwSuW",
            "description"=> nil,
            "dispute"=> nil,
            "metadata"=> {},
            "statement_description"=> "MyFlix"
          }
        },
        "object"=> "event",
        "pending_webhooks"=> 1,
        "request"=> "iar_3tVW0r8ICf4VFq"
      }
  end
  it "creates a payment with the webhook for charge succeeded" do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end
  it "creates a payment associated with the user" do
    user = Fabricate(:user, customer_token: "cus_3tVWkvqzmpjSDY")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(user)
  end
  it "creates a payment with the ammount" do
    user = Fabricate(:user, customer_token: "cus_3tVWkvqzmpjSDY")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end
  it "creates a payment with reference id" do
    user = Fabricate(:user, customer_token: "cus_3tVWkvqzmpjSDY")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_103tVW20rukLV0Woy8rZdBdn")
  end
end