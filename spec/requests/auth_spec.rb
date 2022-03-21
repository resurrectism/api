require 'rails_helper'

RSpec.describe 'Auths', type: :request do
  subject { response }

  let(:headers) { {} }
  let(:attributes) { {} }

  describe 'POST /login' do
    let(:email) { 'someone@email.com' }
    let(:password) { '1234567@aM' }

    before do
      Fabricate(:user, email: email, password: password, password_confirmation: password)

      headers = { 'Content-Type' => 'application/vnd.api+json' }
      params = { data: { attributes: attributes } }
      post login_path, headers: headers, params: params.to_json
    end

    context 'when called with a non-existent email' do
      let(:attributes) { { email: 'someone@mail.com' } }

      it { is_expected.to have_http_status(:unauthorized) }
    end

    context 'when called with wrong password' do
      let(:attributes) { { email: email, password: 'badpassword' } }

      it { is_expected.to have_http_status(:unauthorized) }
    end

    context 'when called with correct password' do
      let(:attributes) { { email: email, password: password } }

      it { is_expected.to have_http_status(:ok) }
    end
  end

  describe 'POST /refresh_token' do
    let(:refresh_token) { nil }

    before do
      Fabricate(:user, refresh_token: refresh_token)

      headers = { 'Content-Type' => 'application/vnd.api+json' }
      params = { data: { attributes: attributes } }
      post refresh_token_path, headers: headers, params: params.to_json
    end

    context 'when called with a valid but non-existent refresh_token' do
      let(:attributes) { { refresh_token: Auth.issue_refresh_token(refresh_token: 'invalid') } }

      it { is_expected.to have_http_status(:unauthorized) }
    end

    context 'when called with an expired refresh token' do
      let(:refresh_token) { 'valid but expired' }
      let(:attributes) do
        { refresh_token: Auth.issue_refresh_token(refresh_token: refresh_token, exp: 10.minutes.ago.to_i) }
      end

      it { is_expected.to have_http_status(:unauthorized) }
    end

    context 'when called with a valid refresh token' do
      let(:refresh_token) { 'valid' }
      let(:attributes) do
        { refresh_token: Auth.issue_refresh_token(refresh_token: refresh_token) }
      end

      it { is_expected.to have_http_status(:ok) }
    end
  end

  describe 'POST /logout' do
    let(:headers) { {} }

    before { post logout_path, headers: headers }

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

      it { is_expected.to have_http_status(:no_content) }
    end
  end
end
