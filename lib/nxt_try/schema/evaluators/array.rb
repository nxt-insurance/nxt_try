module NxtTry
  module Schema
    module Evaluators
      class Array < Evaluators::Base
        def call
          if valid_input? && items_schema_provided?
            result.output = []
            current_input.each_with_index do |_, index|
              path = current_path + [index]

              evaluator = Evaluator.new(
                schema: items_schema,
                input: input,
                current_path: path,
                node_accessor: node_accessor,
                config: config
              ).call

              children << evaluator
              evaluator.result.errors.each { |_, error| result.add_error(error, path) }
              result.output[index] = evaluator.result.output
            end

            run_validations
          elsif valid_input? && !items_schema_provided?
            result.output = current_input
            coerce_input
            run_validations
          else
            result.output = current_input
            coerce_input
          end

          self
        end

        private

        def items_schema_provided?
          !items_schema.is_a?(Undefined)
        end

        def items_schema
          schema.fetch(:items, Undefined.new)
        end
      end
    end
  end
end