module NxtTry
  module Conditions
    module Evaluators
      class Base
        include TypeDefinitions
        CONDITIONAL_KEYS = [:if, :then, :else, :case, :when]

        def initialize(schema:, input:, current_path: [], node_accessor:, config:)
          @input = input
          @current_path = current_path
          @node_accessor = node_accessor
          @config = config
          @schema = resolve_defined_type(schema)
        end

        attr_reader :schema, :input, :current_path, :node_accessor, :config

        def call
          raise NotImplementedError
        end

        private

        def apply_conditional_schemas
            evaluate_case_statement
        end

        def apply_if_statement
          return unless if_statement

          conditional_schemas = if statement.evaluate(node_accessor)
            statement.then_statement
          else
            statement.else_statement
          end

          merge_and_replace_schemas(conditional_schemas)

          result
        end

        def merge_and_replace_schemas(conditional_schemas)
          schemas_to_apply = conditional_schemas.slice(:merge, :replace)
          schema_to_merge = schemas_to_apply[:merge]

          schema.deep_merge!(schema_to_merge) if schema_to_merge.present?

          schema_to_replace = schemas_to_apply[:replace]

          if schema_to_replace.present?
            schema_to_replace.each do |key, value|
              if value
                schema[key] = value
              else
                # Allow to delete keys --> TODO: Test this
                schema.delete(key)
              end
            end
          end
        end

        def evaluate_case_statement
          return unless case_statement
          then_statement = case_statement.evaluate(node_accessor)

          if then_statement
            merge_and_replace_schemas(then_statement)
          else
            else_schema = case_statement.else_statement
            merge_and_replace_schemas(else_schema)
          end
        end

        def if_statement
          # TODO: Clone schema instead of extracting
          @if_statement ||= Expressions::IfElseStatement.extract!(schema)
        end

        def case_statement
          @case_statement ||= Expressions::CaseWhenStatement.extract!(schema)
        end
      end
    end
  end
end