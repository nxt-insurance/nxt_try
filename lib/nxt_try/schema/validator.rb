module NxtTry
  module Schema
    class Validator
      include CanAccessNodes

      def initialize(expression:, node_type:, input:, node_accessor:, errors: [], config:)
        @expression = Validators::Expression.new(expression, node_type)
        @node_type = node_type
        @input = input
        @node_accessor = node_accessor
        @errors = errors
        @config = config
      end

      attr_reader :expression, :node_type, :input, :node_accessor, :errors, :config


      # validations: { equals: '' }
      # validations: { and: [{ pattern: '\d+' }, { size: 5 }] }
      # validations: { and: [{ or: [{},{}], { pattern: '\d+'} } ] }
      # returns an array of errors or an empty array
      def call
        if expression.logic?
          # returns an array of errors
          self.errors += expression.evaluator.new(
            config: config,
            expression: expression.raw,
            node_accessor: node_accessor,
            input: input,
            errors: [],
            node_type: node_type
          ).call

          errors
        elsif expression.validation?
          arg = evaluate_path_or_value(expression.right)
          result = expression.evaluator.new(input, arg).call
          # returns a single error or an instance of Success - we are only interested in errors
          errors << result unless result.is_a?(Validators::Success)
          errors
        else
          raise ArgumentError, "Could not resolve type of expression: #{expression}"
        end
      end

      private

      attr_accessor :errors
    end
  end
end