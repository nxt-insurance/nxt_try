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
      def call
        if expression.logic?
          expression.evaluator.new(
            config: config,
            expression: expression.raw,
            node_accessor: node_accessor,
            input: input,
            node_type: node_type,
            errors: errors
          ).call
        elsif expression.validation?
          arg = evaluate_path_or_value(expression.right)
          errors << expression.evaluator.new(input, arg).call
        else
          raise ArgumentError, "Could not resolve type of expression: #{expression}"
        end
      end
    end
  end
end