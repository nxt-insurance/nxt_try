module NxtTry
  module Conditions
    module Evaluators
      module Expressions
        class IfElseStatement
          KEYS = [:if, :then, :else]
          # { if: {}, then: {}, else: {} }
          #
          def self.extract!(schema)
            extracted_statement = KEYS.inject({}) do |extract, key|
              extract[key] = schema.delete(key)
              extract
            end

            statement = new(extracted_statement.compact)
            return unless statement.valid?

            statement
          end

          def initialize(statement)
            @statement = statement
          end

          def if_statement
            statement.fetch(:if)
          end

          def then_statement
            statement.fetch(:then)
          end

          def else_statement
            statement.fetch(:else, {})
          end

          def evaluate(node_accessor)
            NxtTry::Conditions::Expressions::Evaluator.new(
              expression: if_statement,
              node_accessor: node_accessor
            ).call
          end

          def valid?
            # TODO: Raise error
            statement.key?(:if) && statement.key?(:then)
          end

          private

          attr_reader :statement
        end
      end
    end
  end
end