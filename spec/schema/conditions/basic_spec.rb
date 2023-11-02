RSpec.describe NxtTry::Evaluator do

  context 'hash root' do
    let(:schema) do
      {
        type: 'hash',
        attributes: {
          country: { type: 'string' },
          country_code: {
            type: 'string',
            validations: { enum: 'de' },
            case: [
              { if: { '/country': { equals: 'France' } }, then: { merge: { validations: { enum: 'fr' } } } },
              { if: { '/country': { equals: 'England' } }, then: { merge: { validations: { enum: 'gb' } } } }
            ]
          }
        }
      }
    end

    let(:input) do
      {
        country_code: 'fr',
        country: 'Germany'
      }
    end

    it 'builds the schema' do
      result = described_class.new(schema: schema, input: input).call
      binding.pry
    end
  end
end