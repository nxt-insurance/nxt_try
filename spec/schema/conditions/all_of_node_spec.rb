RSpec.describe NxtTry::Evaluator do

  context 'all of node with conditions' do
    let(:schema) do
      {
        type: 'hash',
        attributes: {
          phone_number: {
            type: {
              and: [
                { type: 'string', validations: { size: 5 } },
                { type: 'string', validations: { pattern: '\d+' } }
              ]
            },
            if: { '/phone_number': { equals: '12345' } },
            then: { replace: { type: 'string', validations: { enum: '12345' } } }
          }
        }
      }
    end

    let(:input) do
      { phone_number: '12345' }
    end

    it 'builds the schema' do
      result = described_class.new(schema: schema, input: input).call
      binding.pry
    end
  end
end