module NxtTry
  module Schema
    module Validators
      module Logic
        class And < Base
          def call
            # left | and: [{ expr }, { expr }] | right
            right.inject([]) do |acc, expr|
              acc + Validator.new(
                expression: expr,
                node_accessor: node_accessor,
                node_type: node_type,
                input: input,
                config: config
              ).call
            end
          end
        end
      end
    end
  end
end
