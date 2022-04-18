require 'rails_helper'

RSpec.describe Track, type: :model do
  subject(:track) do
    Fabricate(:track)
  end

  it { is_expected.to validate_presence_of(:language) }
  it { is_expected.to validate_uniqueness_of(:language) }
end
