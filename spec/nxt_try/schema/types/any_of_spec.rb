RSpec.describe NxtTry::Evaluator do

  subject { described_class.new(schema: schema.to_json).call(input.to_json) }

  context 'any_of primitives' do
    let(:schema) do
      {
        type: 'array',
        items: {
          type: {
            any_of: [{ type: 'string' }, { type: 'integer' }]
          }
        }
      }
    end

    context 'when valid' do
      let(:input) { ['77855', 77855, 67661] }

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

  context 'more complex any_of' do
    let(:types) do
      {
        bike: {
          type: 'hash',
          attributes: {
            color: { type: 'string' }
          }
        },
        car: {
          type: 'hash',
          attributes: {
            horse_power: { type: 'integer' }
          }
        },
        device: {
          type: 'hash',
          attributes: {
            expensive: { type: 'boolean' }
          }
        }
      }
    end

    let(:type_registry) { NxtTry.build_type_registry(types) }

    let(:schema) do
      {
        type: 'hash',
        attributes: {
          valuable: {
            type: {
              any_of: [
                { type: '#bike' },
                { type: '#car' },
                { type: '#device' }
              ]
            }
          }
        }
      }
    end

    let(:inputs) do
      [
        {
          valuable: {
            color: 'green'
          }
        },
        {
          valuable: {
            horse_power: 100
          }
        },
        {
          valuable: {
            expensive: true
          }
        }
      ]
    end

    it do
      inputs.each do |input|
        result = NxtTry.evaluator(options: { defined_types: type_registry }).call(schema).call(input)
        expect(result).to be_valid
        expect(result.output).to eq(input)
      end
    end
  end
end