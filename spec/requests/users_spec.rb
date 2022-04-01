require 'rails_helper'

RSpec.describe 'Users', type: :request do
  subject { response }

  describe 'POST /users' do
    let(:attributes) { {} }

    before do
      headers = { 'Content-Type' => 'application/vnd.api+json' }
      params = { data: { type: 'user', attributes: attributes } }
      post users_path, headers: headers, params: params.to_json
    end

    context 'when called without a password' do
      let(:attributes) { { email: 'someone@email.com' } }

      it { is_expected.to have_http_status(:unprocessable_entity) }
    end

    context 'when called without a confirm password' do
      let(:attributes) { { email: 'someone@email.com', password: '1234567@aM' } }

      it { is_expected.to have_http_status(:unprocessable_entity) }
    end

    context 'when called with all necessary fields' do
      let(:attributes) do
        {
          email: 'someone@email.com',
          password: '1234567@aM',
          password_confirmation: '1234567@aM',
        }
      end

      it { is_expected.to have_http_status(:created) }
    end
  end

  describe 'GET /profile' do
    let(:headers) { {} }

    before { get profile_path, headers: headers }

    context 'when called without a bearer token' do
      it { is_expected.to have_http_status(:unauthorized) }
    end

    context 'when called with an invalid bearer token' do
      let(:headers) { { 'Authorization' => 'invalidBearerToken' } }

      it { is_expected.to have_http_status(:unauthorized) }
    end

    context 'when called with a valid bearer token' do
      let(:headers) do
        user = Fabricate(:user)
        token = Auth.issue_access_token(user: user.id)

        { 'Authorization' => "Bearer #{token}" }
      end

      it { is_expected.to have_http_status(:ok) }
    end
  end
end
