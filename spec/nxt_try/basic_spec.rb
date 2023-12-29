RSpec.describe NxtTry::Evaluator do

  subject { NxtTry.evaluator[schema].call(input) }

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
      expect(subject).to be_valid
      expect(subject.output).to eq(input)
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
      expect(subject.to_h).to match(
                               {:errors=>
                                  {"0"=> be_a(Array)},
                                    :output=>
                                      [1,
                                       {:first_name=>"Andy", :last_name=>"Superstar"},
                                       {:first_name=>"Andy", :last_name=>"Candy"}]}
                             )
    end
  end

  context 'primitive root' do
    let(:schema) do
      { type: 'string' }
    end

    context 'when valid' do
      let(:input) { '"this is my input"' }

      it do
        expect(subject).to be_valid
      end
    end

    context 'when invalid' do
      let(:input) { '12' }

      it do
        expect(subject).not_to be_valid
      end
    end
  end
end