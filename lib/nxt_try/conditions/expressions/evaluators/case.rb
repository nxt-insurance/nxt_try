module NxtTry
  module Conditions
    module Expressions
      module Evaluators
        class Case
          def initialize(case_expressions, node_accessor)
            @case_expressions = case_expressions
            @node_accessor = node_accessor
          end

          def call
            case_expressions.each do |case_expression|

            end
          end

          private

          attr_reader :left, :right
        end
      end
    end
  end
end