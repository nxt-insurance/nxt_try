RSpec.describe NxtTry::Conditions::Evaluator do

  subject do
    described_class.new(
      schema: schema,
      input: input,
      config: config
    ).call
  end

  let(:config) { NxtTry::Config.new(schema: schema, options: {}) }

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
              { when: { '/country': { equals: 'France' } }, then: { merge: { validations: { enum: 'fr' } } } },
              { when: { '/country': { equals: 'England' } }, then: { merge: { validations: { enum: 'gb' } } } }
            ]
          }
        }
      }
    end

    let(:input) do
      {
        country_code: 'fr',
        country: 'France'
      }
    end

    it 'builds the schema' do
      subject
    end
  end
end