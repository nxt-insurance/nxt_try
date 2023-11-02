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
          else
            return unless if_statement_complete?(if_statement)
            apply_if_statement_schemas(if_statement)
          end


          # schema_to_apply = conditional_schemas.slice(:merge, :replace)
          # return unless schema_to_apply.any?
          #
          # schema_to_merge = schema_to_apply[:merge]
          # # TODO: Does this even make sense?
          # schema_to_replace = schema_to_apply[:replace]
          #
          # if schema_to_merge
          #   schema_to_merge.each do |key, value|
          #     # TODO: Don't allow to switch the type???
          #     # next if key.to_s == 'type'
          #
          #     if value
          #       schema[key] = value
          #     else
          #       schema.delete(key)
          #     end
          #   end
          # end
        end

        def apply_if_statement_schemas(statement)
          result = evaluate_if_statement(statement.fetch(:if))

          conditional_schemas = if result
                                  statement.fetch(:then)
                                else
                                  statement.fetch(:else, {})
                                end

          schema_to_apply = conditional_schemas.slice(:merge, :replace)
          # TODO: Apply schemas here

          result
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
            schema_to_apply = case_statement.fetch(:else, {})
            # TODO: Apply else schema
          end
        end

        # def conditional_schemas
        #   return {} unless condition?
        #
        #   if evaluate_condition
        #     condition.fetch(:then)
        #   else
        #     condition.fetch(:else, {})
        #   end
        # end

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