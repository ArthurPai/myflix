require 'spec_helper'

describe 'Create payment on successful charge' do
  let(:event_data) do
    {
      'id'       => 'evt_14K2QH4qb12mBuvU0AFZC4fy',
      'created'  => 1406270601,
      'livemode' => false,
      'type'     => 'charge.succeeded',
      'data'     => {
        'object' => {
          'id'       => 'ch_14K2QG4qb12mBuvUz4bgx7nE',
          'object'   => 'charge',
          'created'  => 1406270600,
          'livemode' => false,
          'paid'     => true,
          'amount'   => 999,
          'currency' => 'usd',
          'refunded' => false,
          'card'     => {
            'id'                  => 'card_14K2QE4qb12mBuvUa4JFG2wd',
            'object'              => 'card',
            'last4'               => '4242',
            'brand'               => 'Visa',
            'funding'             => 'credit',
            'exp_month'           => 7,
            'exp_year'            => 2017,
            'fingerprint'         => 'onp2Ks0f4lLaXxop',
            'country'             => 'US',
            'name'                => nil,
            'address_line1'       => nil,
            'address_line2'       => nil,
            'address_city'        => nil,
            'address_state'       => nil,
            'address_zip'         => nil,
            'address_country'     => nil,
            'cvc_check'           => 'pass',
            'address_line1_check' => nil,
            'address_zip_check'   => nil,
            'customer'            => 'cus_4SyN7CrxZnUF8a'
          },
          'captured' => true,
          'refunds'  => {
            'object'      => 'list',
            'total_count' => 0,
            'has_more'    => false,
            'url'         => '/v1/charges/ch_14K2QG4qb12mBuvUz4bgx7nE/refunds',
            'data'        => []
          },
          'balance_transaction'   => 'txn_14K2QG4qb12mBuvU6n4qyGWq',
          'failure_message'       => nil,
          'failure_code'          => nil,
          'amount_refunded'       => 0,
          'customer'              => 'cus_4SyN7CrxZnUF8a',
          'invoice'               => 'in_14K2QG4qb12mBuvUDXgWub6V',
          'description'           => nil,
          'dispute'               => nil,
          'metadata'              => {},
          'statement_description' => 'Just',
          'receipt_email'         => nil
        }
      },
      'object'           => 'event',
      'pending_webhooks' => 1,
      'request'          => 'iar_4SyNnPbgQWqlKT'
    }
  end

  it 'creates a payment with the webhook from stripe for charge succeeded', :vcr do
    post '/stripe_events', event_data
    expect(Payment.count).to eq(1)
  end

  it 'creates a payment association with the user', :vcr do
    john = Fabricate(:user, stripe_customer_id: 'cus_4SyN7CrxZnUF8a')
    post '/stripe_events', event_data
    expect(Payment.first.user).to eq(john)
  end

  it 'creates a payment with the charge reference id', :vcr do
    post '/stripe_events', event_data
    expect(Payment.first.reference_id).to eq('ch_14K2QG4qb12mBuvUz4bgx7nE')
  end

  it 'creates a payment with the charge amount', :vcr do
    post '/stripe_events', event_data
    expect(Payment.first.amount).to eq(999)
  end
end