RSpec.describe NxtTry::Evaluator do

  let(:schema) do
    {
      type: 'hash',
      attributes: {
        deductible: { type: 'integer', filters: ['pricing'] },
        previous_insurance: { type: 'boolean' },
        previous_insurance_name: {
          type: 'string',
          required: { '/previous_insurance': { equals: true } }
        }
      }
    }
  end

  subject { described_class.new(schema: schema, options: { filters: 'pricing' }).call(input) }

  let(:input) { { deductible: 10000 } }

  context 'when filter applies' do
    it 'only includes the nodes to which the filter applies' do
      expect(subject.output).to eq(:deductible=>10000)
    end
  end
end