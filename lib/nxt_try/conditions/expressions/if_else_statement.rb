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

            new(extracted_statement.compact)
          end

          def initialize(statement)
            @statement = statement
            validate
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

          private

          attr_reader :statement

          def validate
            # TODO: Raise proper error
            if_statement && then_statement
          end
        end
      end
    end
  end
end