module NxtTry
  module Conditions
    module Expressions
      class Evaluator
        include CanAccessNodes

        def initialize(expression:, node_accessor:)
          @expression = Expression.new(expression)
          @node_accessor = node_accessor
        end

        def call
          if expression.logic?
            expression.logic_evaluator.new(expression: expression.raw, node_accessor: node_accessor).call
          elsif expression.binary?
            args = [expression.left, expression.right.values.first]
            args = args.map { |arg| evaluate_path_or_value(arg) }

            expression.binary_evaluator.new(*args).call
          else
            raise ArgumentError, "Could not resolve evaluator for expression: #{expression.raw}"
          end
        end

        private

        attr_reader :expression, :node_accessor
      end
    end
  end
end