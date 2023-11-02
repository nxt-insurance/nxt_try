RSpec.describe NxtTry::Evaluator do

  context 'hash root' do
    let(:schema) do
      {
        definitions: {
          types: {
            zip_code: {
              type: 'string',
              pattern: '\d{5}'
            },
            address: {
              type: 'hash',
              attributes: {
                street: { type: 'string' },
                street_number: { type: 'string' },
                city: { type: 'string' },
                zip_code: { type: '#zip_code' }
              }
            },
          },
        },
        type: 'hash',
        attributes: {
          address: { type: '#address' },
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
          zip_code: '67661'
        },
        country: 'Germany'
      }
    end

    it 'builds the schema' do
      result = described_class.new(schema: schema, input: input).call
      expect(result.to_h).to eq(
                               {:errors=>{},
                                :output=>
                                  {:address=>
                                     {:street=>"Kirchgasse", :street_number=>"1", :city=>"Augsburg", :zip_code=>"67661"},
                                   :country=>"Germany"}}
                             )
    end
  end
end