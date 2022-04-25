require 'rails_helper'

RSpec.describe HealthCheckController, type: :routing do
  describe 'routing' do
    it 'routes to #ping' do
      expect(get: '/ping').to route_to('health_check#ping')
    end

    it 'routes to #health_check' do
      expect(get: '/health_check').to route_to('health_check#health_check')
    end
  end
end
