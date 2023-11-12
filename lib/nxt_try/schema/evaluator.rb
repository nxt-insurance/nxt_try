module NxtTry
  module Schema
    class Evaluator
      include TypeDefinitions

      def initialize(schema:, input:, current_path: [], config:, parent_node: nil)
        @input = input
        @current_path = current_path
        @config = config

        @schema = resolve_defined_type(schema)
        @result = nil
        @parent_node = parent_node
      end

      attr_reader :schema, :input, :current_path, :config, :parent_node

      def call
        evaluate_schema
      end

      def evaluate_schema
        options = {
          schema: schema,
          input: input,
          current_path: current_path,
          config: config,
          parent_node: parent_node
        }

        type = schema.fetch(:type)
        type = resolve_type_expression(type)

        case type.to_s
        when 'any_of', 'or'
          NxtTry::Schema::Evaluators::AnyOf.new(**options).call
        when 'all_of', 'and'
          NxtTry::Schema::Evaluators::AllOf.new(**options).call
        when *NxtTry::Types::HASHES
          NxtTry::Schema::Evaluators::Hash.new(**options).call
        when *NxtTry::Types::ARRAYS
          NxtTry::Schema::Evaluators::Array.new(**options).call
        when *NxtTry::Types::PRIMITIVES
          NxtTry::Schema::Evaluators::Primitive.new(**options).call
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
