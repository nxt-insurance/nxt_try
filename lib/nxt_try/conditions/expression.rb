module NxtTry
  module Conditions
    class Expression
      # if: { and: [{ ... }, { ... }]}
      # if: { '-> /path/to/node': { equals: 'value' } }
      # if: { not: '' }
      # case: '/path/to/value'
      # case: [{ if: {}, then: { }}
      #
      # ]
      # TODO: Case statement would be nice

      def initialize(raw)
        @raw = raw

        @left = raw.keys.first
        @right = raw.values.first
        @binary_operator = right.keys.first

        @type = parse_type
      end

      attr_reader :raw, :type, :left, :right, :binary_operator

      def logic?
        logic_evaluator.present?
      end

      def binary?
        binary_evaluator.present?
      end

      def logic_evaluator
        @logic_evaluator ||= NxtTry::Conditions::Expressions::Evaluators::Logic::Registry.resolve(left)
      end

      def binary_evaluator
        @binary_evaluator ||= NxtTry::Conditions::Expressions::Evaluators::Registry.resolve(binary_operator)
      end

      private

      def parse_type
        if logic?
          'logic'
        elsif binary?
          'binary'
        else
          raise ArgumentError, "Could not resolve type of expression: #{raw}"
        end
      end
    end
  end
end