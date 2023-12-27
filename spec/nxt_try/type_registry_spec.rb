RSpec.describe NxtTry do
  describe '.load_types' do
    let(:types) do
      {
        user: {
          type: 'namespace',
          definitions: {
            address: {
              type: 'object',
              attributes: {
                street: { type: 'string' },
                house_number: { type: 'string' },
                zip_code: { type: 'string' },
                city: { type: 'string' }
              }
            },
            email: {
              type: 'string',
              validations: { pattern: '.*@.*' }
            }
          }
        },
        environment: {
          type: 'namespace',
          definitions: {
            production: {
              type: 'namespace',
              definitions: {
                host: {
                  type: 'string',
                  validations: '.*production.*'
                }
              }
            },
            staging: {
              type: 'namespace',
              definitions: {
                host: {
                  type: 'string',
                  validations: '.*staging.*'
                }
              }
            }
          }
        }
      }
    end

    before { NxtTry.load_types(types) }

    it 'registers the types' do
      expect(NxtTry::TypeRegistry.keys).to eq(%w[user.address user.email environment.production.host environment.staging.host])
      expect(NxtTry::TypeRegistry.resolve('environment.staging.host')).to eq({:type=>"string", :validations=>".*staging.*"})
    end
  end
end