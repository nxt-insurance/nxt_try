RSpec.describe NxtTry::Evaluator do

  subject { described_class.new(schema: schema).call(input) }

  context 'lengthy string' do
    let(:schema) do
      {
        type: 'hash',
        attributes: { country: { type: 'string!' } }
      }
    end

    context 'when blank' do
      let(:input) { { country: '' } }

      it do
        expect(subject).to_not be_valid
      end
    end

    context 'when not blank' do
      let(:input) { { country: 'DE' } }

      it { expect(subject).to be_valid }
    end
  end
end