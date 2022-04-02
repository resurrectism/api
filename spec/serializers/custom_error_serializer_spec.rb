RSpec.describe CustomErrorSerializer do
  describe '#as_json' do
    subject(:error_serializer) { described_class.new(*errors) }

    let(:errors) { [{ attribute: 'some', message: 'some' }] }

    it 'renders the models errors' do
      expect(error_serializer.as_json).to match(errors: include(
        {
          source: { pointer: '/data/attributes/some' },
          detail: 'some',
        }
      ))
    end
  end
end
