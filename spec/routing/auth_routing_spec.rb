require 'rails_helper'

RSpec.describe AuthController, type: :routing do
  describe 'routing' do
    it 'routes to #login' do
      expect(post: '/users/login').to route_to('auth#login')
    end

    it 'routes to #refresh_token' do
      expect(post: '/users/refresh_token').to route_to('auth#refresh_token')
    end

    it 'routes to #logout' do
      expect(post: '/users/logout').to route_to('auth#logout')
    end
  end
end
