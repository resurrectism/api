require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /profile' do
    subject { response }

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
