RSpec.describe NxtTry::Evaluator do

  subject { described_class.new(schema: schema.to_json, input: input.to_json).call }

  context 'hash with arbitrary attributes' do
    let(:schema) do
      {
        type: 'hash',
        value: { validate: { length: 2 } }
      }
    end

    context 'when valid' do
      let(:input) {
        {
          first_name: 'Andy',
          last_name: 'Robecke'
        }
      }

      it do
        expect(subject).to be_valid
        expect(subject.output).to eq(:first_name=>"Andy", :last_name=>"Robecke")
      end
    end

    context 'when invalid type' do
      let(:input) { [] }

      it do
        expect(subject).to_not be_valid
      end
    end

    context 'when validation fails' do
      let(:input) { {} }

      it do
        expect(subject).to_not be_valid
        expect(subject.errors).to eq("root"=>["Length of {} does not match 2"])
      end
    end
  end
end