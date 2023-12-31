module NxtTry
  module Schema
    module Required
      class Evaluator
        include CanAccessNodes

        def initialize(expression:, input:, node_accessor:, config:)
          @expression = Expression.new(expression)
          @input = input
          @node_accessor = node_accessor
          @config = config
        end

        attr_reader :expression, :input, :node_accessor, :config

        def call
          if expression.logic? || expression.required?
            expression.evaluator.new(
              config: config,
              expression: expression.raw,
              node_accessor: node_accessor,
              input: input
            ).call
          else
            raise ArgumentError, "Could not resolve type of expression: #{expression}"
          end
        end
      end
    end
  end
end