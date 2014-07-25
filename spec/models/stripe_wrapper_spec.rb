require 'spec_helper'

describe StripeWrapper do
  before do
    StripeWrapper.set_api_key
  end

  let(:token) {
    Stripe::Token.create(
        :card => {
            :number => card_number,
            :exp_month => 7,
            :exp_year => 2025,
            :cvc => '314'
        },
    ).id
  }

  describe StripeWrapper::Charge do
    context 'with valid card', :vcr do
      let(:card_number) { '4242424242424242' }

      it 'charge the card successfully' do
        response = StripeWrapper::Charge.create(amount: 300, card: token, description: 'The testing description')

        expect(response).to be_successfully
      end
    end

    context 'with invalid card', :vcr do
      let(:card_number) { '4000000000000002' }
      let(:response) { StripeWrapper::Charge.create(amount: 300, card: token, description: 'The testing description') }

      it 'does not charge the card successfully' do
        expect(response).not_to be_successfully
      end

      it 'contains the error message', :vcr do
        expect(response.error_message).to eq('Your card was declined.')
      end
    end
  end

  describe StripeWrapper::Customer do
    context 'with valid card', :vcr do
      let(:card_number) { '4242424242424242' }
      let(:response) { StripeWrapper::Customer.create(plane: 'Basic', card: token, description: 'The plane testing description') }

      it 'creates a customer' do
        expect(response).to be_successfully
      end

      it 'gets the customer id from stripe server' do
        expect(response.id).to be_present
      end
    end

    context 'with invalid card', :vcr do
      let(:card_number) { '4000000000000002' }
      let(:response) { StripeWrapper::Customer.create(plane: 'Basic', card: token, description: 'The testing plane description') }

      it 'does not create a customer' do
        expect(response).not_to be_successfully
      end

      it 'contains the error message', :vcr do
        expect(response.error_message).to eq('Your card was declined.')
      end
    end
  end
end