require 'rails_helper'

RSpec.describe '/exercises', type: :request do
  subject { response }

  let(:exercise) { Fabricate(:exercise) }
  let(:headers) do
    user = Fabricate(:user)
    token = Auth.issue_access_token(user: user.id)

    { 'Authorization' => "Bearer #{token}" }
  end

  describe 'GET /exercises' do
    before { get exercises_url, headers: headers, as: :json }

    context 'when called without a bearer token' do
      let(:headers) { {} }

      it { is_expected.to have_http_status(:unauthorized) }
    end

    context 'when called with an invalid bearer token' do
      let(:headers) { { 'Authorization' => 'invalidBearerToken' } }

      it { is_expected.to have_http_status(:unauthorized) }
    end

    context 'when called with a valid bearer token' do
      it { is_expected.to have_http_status(:ok) }
    end
  end

  describe 'GET /show' do
    before { get exercises_url(exercise), headers: headers, as: :json }

    context 'when called without a bearer token' do
      let(:headers) { {} }

      it { is_expected.to have_http_status(:unauthorized) }
    end

    context 'when called with an invalid bearer token' do
      let(:headers) { { 'Authorization' => 'invalidBearerToken' } }

      it { is_expected.to have_http_status(:unauthorized) }
    end

    context 'when called with a valid bearer token' do
      it { is_expected.to have_http_status(:ok) }
    end
  end
end
