RSpec.describe NxtTry::Evaluator do

  context 'hash root' do
    let(:schema) do
      {
        type: 'hash',
        attributes: {
          address: {
            type: 'hash',
            attributes: {
              street: { type: 'string' },
              street_number: { type: 'string' },
              city: { type: 'string' },
              zip_code: { type: 'integer' }
            }
          },
          country: { type: 'string' }
        }
      }
    end

    let(:input) do
      {
        address: {
          street: 'Kirchgasse',
          street_number: '1',
          city: 'Augsburg',
          zip_code: 67661
        },
        country: 'Germany'
      }
    end

    it 'builds the schema' do
      result = described_class.new(schema: schema, input: input).call

      expect(result).to be_valid
      expect(result.output).to eq(input)
    end
  end

  context 'array root' do
    let(:schema) do
      {
        type: 'array',
        items: {
          type: 'hash',
          attributes: {
            first_name: { type: 'string' },
            last_name: { type: 'string' }
          }
        }
      }
    end

    let(:input) do
      [
        1,
        { first_name: 'Andy', last_name: 'Superstar' },
        { first_name: 'Andy', last_name: 'Candy' }
      ]
    end

    it 'builds the schema' do
      result = described_class.new(schema: schema, input: input).call
      expect(result.to_h).to match(
                               {:errors=>
                                  {"0"=> be_a(Array)},
                                    :output=>
                                      [1,
                                       {:first_name=>"Andy", :last_name=>"Superstar"},
                                       {:first_name=>"Andy", :last_name=>"Candy"}]}
                             )
    end
  end
end