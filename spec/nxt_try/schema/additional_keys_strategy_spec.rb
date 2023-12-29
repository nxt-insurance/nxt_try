RSpec.describe NxtTry::Evaluator do

  let(:types) do
    {
      address: {
        type: 'hash',
        attributes: {
          street: { type: 'string' },
          street_number: { type: 'string' },
          city: { type: 'string' },
          zip_code: { type: 'string' }
        }
      },
      zip_code: {
        type: 'string',
        validations: { pattern: '\d{5}' }
      }
    }
  end

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
        zip_code: '67661',
        apartment: '5',
        district: '5'
      },
      country: 'Germany'
    }
  end

  let(:type_registry) { NxtTry.build_type_registry(types) }

  subject { described_class.new(schema: schema, options: options).call(input) }

  context 'reject additional keys ' do
    let(:options) { { additional_keys_strategy: 'reject', defined_types: type_registry } }

    it do
      expect(subject).to be_valid
      expect(subject.output).to eq(
        :address=>{:street=>"Kirchgasse", :street_number=>"1", :city=>"Augsburg", :zip_code=>"67661"}, :country=>"Germany"
      )
    end
  end

  context 'allow additional keys ' do
    let(:options) { { additional_keys_strategy: 'allow', defined_types: type_registry } }

    it do
      expect(subject).to be_valid
      expect(subject.output).to eq(
        :address=>{:city=>"Augsburg", :street=>"Kirchgasse", :street_number=>"1", :zip_code=>"67661", :apartment=>"5", :district=>"5"}, :country=>"Germany"
      )
    end
  end

  context 'restrict additional keys ' do
    let(:options) { { additional_keys_strategy: 'restrict', defined_types: type_registry } }

    it do
      expect(subject).to_not be_valid
      expect(subject.errors).to eq({"address"=>["contains additional keys: [:apartment, :district]"]})
      expect(subject.output).to eq(
        :address=>{:city=>"Augsburg", :street=>"Kirchgasse", :street_number=>"1", :zip_code=>"67661", :apartment=>"5", :district=>"5"}, :country=>"Germany"
      )
    end
  end
end