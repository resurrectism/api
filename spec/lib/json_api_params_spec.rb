require 'json_api_params'

describe JsonApiParams do
  let(:params) { ActionController::Parameters.new(params_data) }

  def expect_params(converted_params, expected_params)
    expect(converted_params).to be_a(ActionController::Parameters)
    expect(converted_params.to_unsafe_hash.to_h).to eq(expected_params)
  end

  context 'when the structure is as expected' do
    let(:params_data) do
      {
        data: {
          type: 'user',
          attributes: {
            name: 'Johnny',
            email: 'johnny@example.com'
          }
        }
      }
    end

    it 'adds the converted JSON API parameters to the params hash' do
      described_class.convert(params)
      expect_params(params['user'],
                    'name' => 'Johnny',
                    'email' => 'johnny@example.com')
    end
  end

  context 'without attributes' do
    let(:params_data) do
      {
        data: {
          type: 'user'
        }
      }
    end

    it 'adds an empty hash' do
      described_class.convert(params)
      expect_params(params['user'], {})
    end
  end

  context 'with no data param' do
    let(:params_data) do
      {
        animal: {
          name: 'test'
        }
      }
    end

    it 'keeps the params unchanged' do
      expect_params(params, 'animal' => { 'name' => 'test' })
    end
  end
end
