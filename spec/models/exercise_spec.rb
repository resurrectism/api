require 'rails_helper'

RSpec.describe Exercise, type: :model do
  subject(:exercise) do
    Fabricate(:exercise)
  end

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:track_id) }
  it { is_expected.to belong_to(:track) }
end
