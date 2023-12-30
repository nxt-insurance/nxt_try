module NxtTry
  module Schema
    module Validators
      module Logic
        class Base
          def initialize(expression:, node_type:, input:, node_accessor:, errors:, config:)
            @expression = expression
            @left = expression.keys.first
            @right = expression.values.first
            @node_accessor = node_accessor
            @node_type = node_type
            @input = input
            @errors = errors
            @config = config
          end

          def call
            raise NotImplementedError
          end

          private

          attr_reader :expression, :left, :right, :node_accessor, :node_type, :input, :errors, :config
        end
      end
    end
  end
end
