require 'spec_helper'

describe StripeWrapper::Charge do
  before do
    StripeWrapper.set_api_key
  end

  let(:token) {
    token = Stripe::Token.create(
        :card => {
            :number => card_number,
            :exp_month => 7,
            :exp_year => 2025,
            :cvc => '314'
        },
    ).id
  }

  context 'with valid card' do
    let(:card_number) { '4242424242424242' }

    it 'charge the card successfully' do
      response = StripeWrapper::Charge.create(amount: 300, card: token, description: 'It is valid card')

      expect(response).to be_successfully
    end
  end

  context 'with invalid card' do
    let(:card_number) { '4000000000000002' }
    let(:response) { response = StripeWrapper::Charge.create(amount: 300, card: token, description: 'The description') }

    it 'does not charge the card successfully' do
      expect(response).not_to be_successfully
    end

    it 'contains the error message' do
      expect(response.error_message).to eq('Your card was declined.')
    end
  end
end