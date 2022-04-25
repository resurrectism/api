require 'rails_helper'

RSpec.describe 'HealthChecks', type: :request do
  describe 'GET /ping' do
    it 'returns http success' do
      get '/ping'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /health_check' do
    it 'returns http success' do
      get '/health_check'
      expect(response).to have_http_status(:success)
    end
  end
end
