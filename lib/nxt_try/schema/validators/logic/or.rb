module NxtTry
  module Schema
    module Validators
      module Logic
        class Or < Base
          def call
            # left | or: [{ expr }, { expr }] | right
            right.inject(false) do |acc, expr|
              acc || Validator.new(
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
