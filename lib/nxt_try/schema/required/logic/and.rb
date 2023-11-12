module NxtTry
  module Schema
    module Required
      module Logic
        class And < Base
          def call
            # left | and: [{ expr }, { expr }] | right
            right.inject(true) do |acc, expr|
              acc && Required::Evaluator.new(
                expression: expr,
                node_accessor: node_accessor,
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
