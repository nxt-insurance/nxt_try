module NxtTry
  module Conditions
    class Evaluator
      include TypeDefinitions

      def initialize(schema:, input:, current_path: [], config:, parent_node: nil)
        @input = input
        @current_path = current_path
        @config = config
        @schema = schema_or_defined_schema(schema)
        @parent_node = parent_node
      end

      attr_reader :schema, :input, :current_path, :config, :parent_node

      def call
        evaluate_conditions
      end

      def evaluate_conditions
        options = {
          schema: schema,
          input: input,
          current_path: current_path,
          config: config,
          parent_node: parent_node
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