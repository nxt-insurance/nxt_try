RSpec.describe NxtTry::Evaluator do

  subject { described_class.new(schema: schema.to_json).call(input.to_json) }

  context 'hash with arbitrary attributes' do
    let(:schema) do
      {
        type: 'hash',
        validations: { length: 2 }
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
        expect(subject.errors).to eq("root"=>[{:message=>"Value {} does not match length 2", :reference=>2, :validator=>"length", :value=>{}}])
      end
    end
  end
end