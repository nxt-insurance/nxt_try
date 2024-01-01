RSpec.describe NxtTry::Evaluator do
  # required: { '/path': { traceable: true } }
  context 'when the left side is a path' do

    subject { described_class.new(schema: schema).call(input) }

    context 'and the node is required when the path is traceable' do
      let(:schema) do
        {
          type: 'hash',
          attributes: {
            husband: {
              type: 'string',
              required: { './wife': { traceable: true } }
            },
            wife: { type: 'string' }
          }
        }
      end

      context 'and the path is traceable' do
        let(:input) { { husband: 'Ken', wife: 'Barbie' } }

        it do
          expect(subject).to be_valid
          expect(subject.output).to eq(input)
        end
      end

      context 'but the path is not traceable' do
        let(:input) { { wife: 'Barbie' } }

        it do
          expect(subject).to_not be_valid
          expect(subject.errors).to eq(
            {
              "root"=>[{:value=>{:wife=>"Barbie"}, :reference=>[:husband, :wife], :message=>"root is missing keys [:husband]", :validator=>"keys"}]
            }
          )
        end
      end
    end

    context 'and the node is required when the path is NOT traceable' do
      let(:schema) do
        {
          type: 'hash',
          attributes: {
            husband: {
              type: 'string',
              required: { './wife': { traceable: false } }
            },
            wife: { type: 'string', required: false }
          }
        }
      end

      context 'but the path is traceable' do
        let(:input) { { wife: 'Barbie' } }

        it do
          expect(subject).to be_valid
        end
      end

      context 'and the path is not traceable' do
        let(:input) { { } }

        it do
          expect(subject).to_not be_valid
          expect(subject.errors).to eq(
            {"root"=>[{:value=>{}, :reference=>[:husband, :wife], :message=>"root is missing keys [:husband]", :validator=>"keys"}]}
          )
        end
      end
    end
  end

  context 'when the left side is not a path' do
    let(:schema) do
      {
        type: 'hash',
        attributes: {
          husband: {
            type: 'string',
            required: { 'true': { traceable: true } }
          },
          wife: { type: 'string' }
        }
      }
    end

    let(:input) { { } }

    subject { described_class.new(schema: schema).call(input) }

    it do
      expect { subject }.to raise_error(ArgumentError, 'The left side of a traceable expression must be a path')
    end
  end

  context 'with a path on the right side (expectation)' do
    let(:schema) do
      {
        type: 'hash',
        attributes: {
          # husband is required only when child and wife are traceable
          husband: {
            type: 'string',
            required: { './wife': { traceable: './child' } }
          },
          wife: { type: 'string', required: false },
          child: { type: 'string', required: false }
        }
      }
    end

    subject { described_class.new(schema: schema).call(input) }

    context 'and the right path is traceable' do
      let(:input) { { child: 'Child', wife: 'Barbie' } }

      it do
        expect(subject).to_not be_valid
        expect(subject.errors).to eq(
          {"root"=>[{:value=>{:child=>"Child", :wife=>"Barbie"}, :reference=>[:husband, :wife, :child], :message=>"root is missing keys [:husband]", :validator=>"keys"}]}
        )
      end
    end

    context 'and the right path is not traceable' do
      let(:input) { { wife: 'Barbie' } }

      # ./wife is traceable but ./child is not present and thus results in required: { './wife': { traceable: false } }
      # meaning husband is required only when the wife is not traceable!
      it do
        expect(subject).to be_valid
      end
    end
  end
end