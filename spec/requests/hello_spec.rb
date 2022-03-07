require 'rails_helper'

RSpec.describe 'Hello controller endpoints', type: :request do
  describe 'GET /' do
    it 'responds with "hello" message' do
      get root_path

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
      expect(json_response.message).to eq('hello')
    end
  end
end
