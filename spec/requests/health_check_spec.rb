require 'rails_helper'

RSpec.describe 'HealthChecks', type: :request do
  describe 'GET /ping' do
    before { get '/ping' }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'sets cache headers' do
      expect(response.headers['Cache-Control']).to eq('no-store')
    end
  end

  describe 'GET /health_check' do
    before { get '/health_check' }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'sets cache headers' do
      expect(response.headers['Cache-Control']).to eq('no-store')
    end
  end
end
