module NxtTry
  module Schema
    module Required
      module Logic
        class Base
          def initialize(expression:, input:, node_accessor:, config:)
            @expression = expression
            @left = expression.keys.first
            @right = expression.values.first
            @node_accessor = node_accessor
            @input = input
            @config = config
          end

          def call
            raise NotImplementedError
          end

          private

          attr_reader :expression, :left, :right, :node_accessor, :input, :config
        end
      end
    end
  end
end
