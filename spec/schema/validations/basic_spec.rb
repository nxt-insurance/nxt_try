RSpec.describe NxtTry::Evaluator do

  subject { described_class.new(schema: schema, input: input).call }

  context 'length' do
    let(:schema) do
      {
        type: 'hash',
        attributes: {
          size: {
            type: 'string',
            validations: { enum: %w[S M L] }
          }
        }
      }
    end

    context 'when valid' do
      let(:input) { { size: 'M' } }

      it do
        expect(subject).to be_valid
      end
    end

    context 'when invalid' do
      let(:input) { { size: 'V' } }

      it do
        expect(subject).not_to be_valid
      end
    end
  end

  context 'logic' do
    let(:schema) do
      {
        type: 'hash',
        attributes: {
          size: {
            type: 'string',
            validations: {
              and: [
                { size: 5 },
                { equals: '12345' }
              ]
            }
          }
        }
      }
    end

    context 'when valid' do
      let(:input) { { size: '12345' } }

      it do
        expect(subject).to be_valid
      end
    end

    context 'when invalid' do
      let(:input) { { size: '11111' } }

      it do
        expect(subject).not_to be_valid
      end
    end
  end
end