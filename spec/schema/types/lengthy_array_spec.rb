RSpec.describe NxtTry::Evaluator do

  subject { described_class.new(schema: schema.to_json, input: input.to_json).call }

  context 'lengthy array' do
    let(:schema) do
      {
        type: 'array',
        items: { type: 'string!' },
        value: { validations: { min_length: 5 } }
      }
    end

    context 'when valid' do
      let(:input) { ['DE', 'DE', 'DE', 'DE', 'DE'] }

      it do
        expect(subject).to be_valid
      end
    end

    context 'when invalid' do
      let(:input) { [] }

      it do
        expect(subject).to_not be_valid
      end
    end
  end
end