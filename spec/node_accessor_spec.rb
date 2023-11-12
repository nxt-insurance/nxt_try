RSpec.describe NxtTry::Evaluator do
  let(:schema) {
    {
      type: 'hash',
      attributes: {
        id: { type: 'integer' },
        person: {
          type: 'hash',
          attributes: {
            first_name: { type: 'string' },
            last_name: { type: 'string' }
          }
        },
        address: {
          type: 'hash',
          attributes: {
            street: {
              type: 'hash',
              attributes: {
                name: { type: 'string' },
                number: { type: 'string' },
              },
              if: { '../street/name': { equals: 'Goethe Street' } },
              then: { merge: { attributes: { number: { type: 'integer', validations: { equals: 2 } } } } }
            },
            zip_code: { type: 'string' },
            city: { type: 'string' }
          }
        }
      }
    }
  }

  let(:input) do
    {
      id: 12345,
      person: {
        first_name: 'Andy',
        last_name: 'Superstar'
      },
      address: {
        street: {
          name: 'Goethe Street',
          number: 1
        },
        zip_code: '77855',
        city: 'Berlin'
      }
    }
  end

  subject { described_class.new(schema: schema, input: input).call }

  it do
    expect(subject).to_not be_valid
    expect(subject.errors).to eq({"address"=>[{:value=>1, :reference=>2, :validator=>"equals", :message=>"Value 1 does not equal 2"}]})
  end
end