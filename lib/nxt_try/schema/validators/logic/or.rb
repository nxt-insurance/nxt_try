module NxtTry
  module Schema
    module Validators
      module Logic
        class Or < Base
          def call
            # left | or: [{ expr }, { expr }] | right
            right.inject([]) do |acc, expr|
              errors = Validator.new(
                expression: expr,
                node_accessor: node_accessor,
                node_type: node_type,
                input: input,
                config: config
              ).call

              return [] if errors.empty?

              acc + errors
            end
          end
        end
      end
    end
  end
end
