RSpec.describe NxtTry::Evaluator do

  context 'hash root' do
    let(:types) do
      {
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
        }
      }
    end

    let(:type_registry) { NxtTry.build_type_registry(types) }

    let(:schema) do
      {
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
      result = described_class.new(schema: schema, options: { defined_types: type_registry }).call(input)
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