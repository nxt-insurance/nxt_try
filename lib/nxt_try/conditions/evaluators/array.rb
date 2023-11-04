module NxtTry
  module Conditions
    module Evaluators
      class Array < Base
        def call
          apply_conditional_schemas

          Conditions::Evaluator.new(
            schema: items_schema,
            input: input,
            current_path: path,
            node_accessor: node_accessor,
            config: config
          ).call
        end

        private

        def items_schema
          schema.fetch(:items, {})
        end
      end
    end
  end
end