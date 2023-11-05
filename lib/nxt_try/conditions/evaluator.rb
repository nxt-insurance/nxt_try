module NxtTry
  module Conditions
    class Evaluator
      include TypeDefinitions

      def initialize(schema:, input:, current_path: [], node_accessor: nil, config:)
        @input = input
        @current_path = current_path
        @config = config
        @node_accessor = node_accessor || NodeAccessor.new(schema: schema, input: input, config: config)
        @schema = resolve_defined_type(schema)
      end

      attr_reader :schema, :input, :current_path, :node_accessor, :config

      def call
        evaluate_conditions
      end

      def evaluate_conditions
        options = {
          schema: schema,
          input: input,
          current_path: current_path,
          node_accessor: node_accessor,
          config: config
        }

        type = schema.fetch(:type)
        type = resolve_type_expression(type)

        case type
        when 'any_of'
          NxtTry::Conditions::Evaluators::AnyOf.new(**options).call
        when 'all_of'
          NxtTry::Conditions::Evaluators::AllOf.new(**options).call
        when *NxtTry::Types::HASHES
          NxtTry::Conditions::Evaluators::Hash.new(**options).call
        when *NxtTry::Types::ARRAYS
          NxtTry::Conditions::Evaluators::Array.new(**options).call
        when *NxtTry::Types::PRIMITIVES
          NxtTry::Conditions::Evaluators::Primitive.new(**options).call
        else
          raise NotImplementedError, "Don't know how to parse type #{type}"
        end

        schema
      end

      def resolve_type_expression(type)
        if type.is_a?(::Hash)
          type.keys.first.to_s
        else
          type
        end
      end
    end
  end
end