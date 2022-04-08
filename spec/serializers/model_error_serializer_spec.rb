RSpec.describe ModelErrorSerializer do
  describe '#as_json' do
    subject(:error_serializer) { described_class.new(model) }

    let(:model) { Fabricate(:user) }

    before do
      model.email = 'invalid'
      model.password = nil
    end

    it 'renders the models errors' do
      expect(model.valid?).to be(false)

      expect(error_serializer.as_json).to match(errors: include(
        build_expected_error('/data/attributes/email'),
        build_expected_error('/data/attributes/password')
      ))
    end
  end

  def build_expected_error(pointer)
    {
      source: { pointer: pointer },
      detail: kind_of(String),
    }
  end
end
