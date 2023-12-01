RSpec.describe NxtTry::Evaluator do

  let(:schema) do
    {
      definitions: {
        types: {
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
        zip_code: '67661',
        apartment: '5',
        district: '5'
      },
      country: 'Germany'
    }
  end

  subject { described_class.new(schema: schema, input: input, options: options).call }

  context 'reject additional keys ' do
    let(:options) { { additional_keys_strategy: 'reject' } }

    it do
      expect(subject).to be_valid
      expect(subject.output).to eq(
        :address=>{:street=>"Kirchgasse", :street_number=>"1", :city=>"Augsburg", :zip_code=>"67661"}, :country=>"Germany"
      )
    end
  end

  context 'allow additional keys ' do
    let(:options) { { additional_keys_strategy: 'allow' } }

    it do
      expect(subject).to be_valid
      expect(subject.output).to eq(
        :address=>{:city=>"Augsburg", :street=>"Kirchgasse", :street_number=>"1", :zip_code=>"67661", :apartment=>"5", :district=>"5"}, :country=>"Germany"
      )
    end
  end

  context 'restrict additional keys ' do
    let(:options) { { additional_keys_strategy: 'restrict' } }

    it do
      expect(subject).to_not be_valid
      expect(subject.errors).to eq({"address"=>["contains additional keys: [:apartment, :district]"]})
      expect(subject.output).to eq(
        :address=>{:city=>"Augsburg", :street=>"Kirchgasse", :street_number=>"1", :zip_code=>"67661", :apartment=>"5", :district=>"5"}, :country=>"Germany"
      )
    end
  end
end