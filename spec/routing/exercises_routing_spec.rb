require 'rails_helper'

RSpec.describe ExercisesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/exercises').to route_to('exercises#index')
    end

    it 'routes to #show' do
      expect(get: '/exercises/1').to route_to('exercises#show', id: '1')
    end
  end
end
