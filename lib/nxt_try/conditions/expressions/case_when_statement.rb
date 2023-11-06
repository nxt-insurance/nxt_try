module NxtTry
  module Conditions
    module Evaluators
      module Expressions
        class CaseWhenStatement
          KEYS = [:case, :else]
          # { when: {}, then: {}, else: {} }
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

          def case_statement
            statement.fetch(:case)
          end

          def else_statement
            statement.fetch(:else, {})
          end

          def evaluate(node_accessor)
            case_statement.inject(false) do |acc, when_statement|
              then_statement = acc || evaluate_case(when_statement.fetch(:when), node_accessor) && when_statement.fetch(:then)
              return then_statement if then_statement
            end
          end

          def evaluate_case(when_statement, node_accessor)
            NxtTry::Conditions::Expressions::Evaluator.new(
              expression: when_statement,
              node_accessor: node_accessor
            ).call
          end

          def valid?
            statement.key?(:case)
          end

          private

          attr_reader :statement
        end
      end
    end
  end
end