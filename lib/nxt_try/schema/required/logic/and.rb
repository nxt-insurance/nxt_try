module NxtTry
  module Schema
    module Required
      module Logic
        class And < Base
          def call
            # left | and: [{ expr }, { expr }] | right
            right.inject(true) do |acc, expr|
              acc && Validators.new(
                expression: expr,
                node_accessor: node_accessor,
                node_type: node_type,
                input: input,
                errors: errors,
                config: config
              ).call
            end
          end
        end
      end
    end
  end
end
