RSpec.describe NxtTry::Evaluator do

  subject { described_class.new(schema: schema.to_json, input: input.to_json).call }

  context 'all_of root node' do
    let(:schema) do
      {
        type: {
          all_of: [
            { type: 'string', validations: { size: 5 } },
            { type: 'string', validations: { pattern: '\d+' } },
          ]
        }
      }
    end

    context 'when valid' do
      let(:input) { '12345' }

      it do
        expect(subject).to be_valid
        expect(subject.output).to eq(input)
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
              { type: 'string', value: { validate: { size: 5 } } },
              { type: 'string', value: { validate: { pattern: '\d+' } } },
            ]
          }
        }
      }
    end

    context 'when valid' do
      let(:input) { %w[77855 12567 67661] }

      it do
        expect(subject).to be_valid
        expect(subject.output).to eq(input)
      end
    end

    context 'when invalid' do
      let(:input) { ['77855', 77855, 67661, {}, []] }

      it do
        expect(subject).to_not be_valid
        expect(subject.errors).to be_a(Hash)
      end
    end
  end

  context 'any_of all_of combination' do
    let(:schema) do
      {
        type: 'array',
        items: {
          type: {
            any_of: [
              {
                type:
                  {
                    all_of: [
                      { type: 'string', validations: { size: 5 } },
                      { type: 'string', validations: { pattern: '\d+' } },
                    ]
                  }
              },
              {
                type:
                  {
                    all_of: [
                      { type: 'integer', validations: { greater: 300 } },
                      { type: 'integer', validations: { pattern: '\A3' } },
                    ]
                  }
              }
            ]
          }
        }
      }
    end

    context 'when all or valid' do
      let(:input) { ['77855', '12345', 333, 399, 356] }

      it do
        expect(subject).to be_valid
        expect(subject.output).to eq(input)
      end
    end

    context 'when some are invalid' do
      let(:input) { ['77855', '1234', 333, 399, 456] }

      it do
        expect(subject).to_not be_valid
      end
    end
  end
end