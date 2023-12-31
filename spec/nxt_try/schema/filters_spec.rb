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

      it 'applies only selected types' do
        expect(subject).to_not be_valid
        expect(subject.errors).to eq(
          {"1"=>[{:value=>12345, :reference=>"string", :validator=>"type", :message=>"Could not coerce value into a string"}]}
        )
      end
    end

    context 'without filters' do
      let(:filters) { [] }

      let(:input) { ['string', 12345] }

      it 'applies all types' do
        expect(subject).to be_valid
        expect(subject.output).to eq(input)
      end
    end

    context 'when the filter result in an empty any_of node' do
      let(:filters) { ['other'] }

      let(:input) { ['string', 12345] }

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError, 'Applying the filters: ["other"] for [0] resulted in empty any of node')
      end
    end
  end

  context 'all_of' do
    let(:schema) do
      {
        type: 'array',
        items: {
          type: {
            all_of: [
              { type: 'string', filters: 'mandatory' },
              { type: 'string', validations: { pattern: '\d+' } }]
          }
        }
      }
    end

    subject { described_class.new(schema: schema, options: { filters: filters }).call(input) }

    context 'when the filter applies' do
      let(:filters) { ['mandatory'] }

      let(:input) { %w[string 12345] }

      it 'applies only matching types' do
        expect(subject).to be_valid
        expect(subject.output).to eq(input)
      end
    end

    context 'without filters' do
      let(:filters) { [] }

      let(:input) { %w[string 12345] }

      it 'applies all types' do
        expect(subject).to_not be_valid
        expect(subject.errors).to eq(
          {"0"=>[{:value=>"string", :validator=>"pattern", :reference=>/\d+/, :message=>"Value string is not match (?-mix:\\d+)"}]}
        )
      end
    end

    context 'when the filter result in an empty any_of node' do
      let(:filters) { ['other'] }

      let(:input) { %w[string 12345] }

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError, 'Applying the filters: ["other"] for [0] resulted in empty all of node')
      end
    end
  end
end