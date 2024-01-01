module NxtTry
  module Schema
    module Required
      module Evaluators
        class Traceable
          include CanAccessNodes

          def initialize(expression:, input:, node_accessor:, config:)
            @expression = Expression.new(expression)
            @input = input
            @node_accessor = node_accessor
            @config = config
          end

          def call
            ensure_left_is_path

            if traceability_expected?
              traceable?
            else
              !traceable?
            end
          end

          private

          attr_reader :expression, :input, :node_accessor, :config

          def ensure_left_is_path
            return if PathIdentifier.new(left).call
            raise ArgumentError, 'The left side of a traceable expression must be a path'
          end

          def traceability_expected?
            value = evaluate_path_or_value(right)
            value.is_a?(UnresolvablePath) ? false : !!value
          end

          def traceable?
            !evaluate_path(left).is_a?(UnresolvablePath)
          end

          # This must be a path
          def left
            @left ||= expression.left
          end

          # This can be a path or a value
          def right
            @right ||= expression.right.values.first
          end

          attr_reader :value, :presence_expectation
        end
      end
    end
  end
end