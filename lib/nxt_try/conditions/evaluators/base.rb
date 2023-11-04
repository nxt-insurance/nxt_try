module NxtTry
  module Conditions
    module Evaluators
      class Base
        include TypeDefinitions

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
          if case_statement_complete?
            evaluate_case_statement
          else
            return unless if_statement_complete?(if_statement)
            apply_if_statement_schemas(if_statement)
          end
        end

        def apply_if_statement_schemas(statement)
          result = evaluate_if_statement(statement.fetch(:if))

          conditional_schemas = if result
                                  statement.fetch(:then)
                                else
                                  statement.fetch(:else, {})
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

        def evaluate_if_statement(expression)
          NxtTry::Conditions::Expressions::Evaluator.new(
            expression: expression,
            node_accessor: node_accessor
          ).call
        end

        def evaluate_case_statement
          if_statements = case_statement.fetch(:case) # TODO: Make sure this is an array
          result = if_statements.inject(false) do |acc, statement|
            raise ArgumentError, "Incomplete if statement in case expression" unless if_statement_complete?(statement)
            acc || apply_if_statement_schemas(statement)
          end

          unless result
            else_schema = case_statement.fetch(:else, {})
            merge_and_replace_schemas(else_schema)
          end
        end

        def if_statement_complete?(statement)
          statement.key?(:if) && statement.key?(:then)
        end

        def case_statement_complete?
          case_statement.key?(:case)
        end

        def if_statement
          # TODO: Make sure to validate condition is complete
          schema.slice(:if, :then, :else).compact
        end

        def case_statement
          # TODO: Make sure to validate condition is complete
          schema.slice(:case, :else).compact
        end
      end
    end
  end
end