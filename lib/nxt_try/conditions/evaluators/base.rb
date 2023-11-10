module NxtTry
  module Conditions
    module Evaluators
      class Base
        include TypeDefinitions
        CONDITIONAL_KEYS = [:if, :then, :else, :case, :when]

        def initialize(schema:, input:, current_path: [], config:, parent_node:)
          @input = input
          @current_path = current_path
          @config = config
          @schema = resolve_defined_type(schema)
          @parent_node = parent_node
        end

        attr_reader :schema, :input, :current_path, :node_accessor, :config, :parent_node

        def call
          raise NotImplementedError
        end

        private

        def node_accessor
          @node_accessor ||= NodeAccessor.new(
            schema: schema,
            input: input,
            config: config,
            current_path: current_path,
            parent_node: parent_node,
            node: self
          )
        end

        def apply_conditional_schemas
          apply_case_statement
          apply_if_statement
        end

        def apply_if_statement
          return unless if_statement

          conditional_schemas = if if_statement.evaluate(node_accessor)
                                  if_statement.then_statement
                                else
                                  if_statement.else_statement
                                end

          merge_and_replace_schemas(conditional_schemas)
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

          schema
        end

        def apply_case_statement
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