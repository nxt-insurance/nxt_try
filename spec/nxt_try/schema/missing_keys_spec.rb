RSpec.describe NxtTry::Evaluator do

  let(:types) do
    {
      address: {
        type: 'hash',
        attributes: {
          street: { type: 'string' },
          street_number: { type: 'string' },
          city: {
            type: 'string',
            required: {
              and: [
                { '/address/street': { traceable: true } },
                { '/address/street_number': { traceable: true } }
              ]
            } # when street is present we require city to be present
          },
          zip_code: { type: 'string' }
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
        street_number: '1'
      }
    }
  end

  subject { described_class.new(schema: schema, options: options).call(input) }

  context 'flags missing required keys' do
    let(:options) { { additional_keys_strategy: 'reject', defined_types: type_registry } }

    it do
      expect(subject).to_not be_valid
      expect(subject.errors).to eq(
        {
          "address"=>[{:value=>{:address=>{:street=>"Kirchgasse", :street_number=>"1"}}, :reference=>[:street, :street_number, :city, :zip_code], :message=>"address is missing keys [:city, :zip_code]", :validator=>"keys"}],
          "root"=>[{:value=>{:address=>{:street=>"Kirchgasse", :street_number=>"1"}}, :reference=>[:address, :country], :message=>"root is missing keys [:country]", :validator=>"keys"}]
        }
      )
    end
  end
end