require 'spec_helper'

feature 'Deactivate user on failed charge' do
  let(:event_data) do
    {
      'id'               => 'evt_14K4nv4qb12mBuvUREHslTzn',
      'created'          => 1406279755,
      'livemode'         => false,
      'type'             => 'charge.failed',
      'data'             => {
        'object' => {
          'id'                    => 'ch_14K4nv4qb12mBuvU8vZ1FsNE',
          'object'                => 'charge',
          'created'               => 1406279755,
          'livemode'              => false,
          'paid'                  => false,
          'amount'                => 999,
          'currency'              => 'usd',
          'refunded'              => false,
          'card'                  => {
            'id'                  => 'card_14K4nI4qb12mBuvUs9Fsltht',
            'object'              => 'card',
            'last4'               => '0341',
            'brand'               => 'Visa',
            'funding'             => 'credit',
            'exp_month'           => 5,
            'exp_year'            => 2017,
            'fingerprint'         => 'DmVBVgiuUjbmViI0',
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
            'customer'            => 'cus_4Szsa5LJs1PDyl'
          },
          'captured'              => false,
          'refunds'               => {
            'object'      => 'list',
            'total_count' => 0,
            'has_more'    => false,
            'url'         => '/v1/charges/ch_14K4nv4qb12mBuvU8vZ1FsNE/refunds',
            'data'        => []
          },
          'balance_transaction'   => nil,
          'failure_message'       => 'Your card was declined.',
          'failure_code'          => 'card_declined',
          'amount_refunded'       => 0,
          'customer'              => 'cus_4Szsa5LJs1PDyl',
          'invoice'               => nil,
          'description'           => 'failed charge',
          'dispute'               => nil,
          'metadata'              => {},
          'statement_description' => nil,
          'receipt_email'         => nil
        }
      },
      'object'           => 'event',
      'pending_webhooks' => 1,
      'request'          => 'iar_4T0pMkUDNMEJXD'
    }
  end

  it 'deactivate user with the web hook data from stripe for charge failed', :vcr do
    john = Fabricate(:user, stripe_customer_id: 'cus_4Szsa5LJs1PDyl')
    post '/stripe_events', event_data
    expect(john.reload).not_to be_active
  end
end