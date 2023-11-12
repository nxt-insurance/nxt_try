RSpec.describe NxtTry::Evaluator do

  let(:schema) do
    {
      definitions: {
        types: {
          address: {
            type: 'hash',
            attributes: {
              street: { type: 'string' },
              street_number: { type: 'string' },
              city: {
                type: 'string',
                # '-> /address/street': { traceable: false } => required when /address/street absent
                required: { '/address/street': { traceable: false } }
              },
              zip_code: { type: 'string' }
            }
          },
          zip_code: {
            type: 'string',
            validations: { pattern: '\d{5}' }
          }
        }
      },
      type: 'hash',
      attributes: {
        address: { type: '#address' },
        country: { type: 'string' }
      }
    }
  end

  let(:input) do
    {
      address: {
        street: 'Kirchgasse',
        street_number: '1'
      }
    }
  end

  subject { described_class.new(schema: schema, input: input, options: options).call }

  context 'flags missing required keys' do
    let(:options) { { additional_keys_strategy: 'reject' } }

    it do
      expect(subject).to_not be_valid
      expect(subject.errors).to eq("address"=>["is missing keys: [:zip_code]"], "root"=>["is missing keys: [:country]"])
    end
  end
end