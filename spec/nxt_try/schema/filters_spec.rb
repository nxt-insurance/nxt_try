RSpec.describe NxtTry::Evaluator do

  context 'hash' do
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

  context 'any_of' do
    let(:schema) do
      {
        type: 'array',
        items: {
          type: {
            any_of: [{ type: 'string', filters: 'only_strings' }, { type: 'integer' }]
          }
        }
      }
    end

    subject { described_class.new(schema: schema, options: { filters: filters }).call(input) }

    context 'when the filter applies' do
      let(:filters) { ['only_strings'] }

      let(:input) { ['string', 12345] }

      it 'filters out the other nodes' do
        expect(subject).to_not be_valid
      end
    end

    context 'when the filter does not apply' do
      let(:filters) { [] }

      let(:input) { ['string', 12345] }

      it 'filters out the other nodes' do
        expect(subject).to be_valid
      end
    end

    context 'when the filter result in an empty any_of node' do
      let(:filters) { ['other'] }

      let(:input) { ['string', 12345] }

      it 'filters out the other nodes' do
        expect { subject }.to raise_error(ArgumentError, 'Applying the filters: ["other"] for [0] resulted in empty any of node')
      end
    end
  end

  context 'all_of' do

  end

end