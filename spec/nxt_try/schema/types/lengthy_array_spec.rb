RSpec.describe NxtTry::Evaluator do

  subject { described_class.new(schema: schema.to_json).call(input.to_json) }

  context 'lengthy array' do
    let(:schema) do
      {
        type: 'array',
        items: { type: 'string!' },
        validations: { length: 5 }
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