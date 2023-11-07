module NxtTry
  module Conditions
    module Evaluators
      class Array < Base
        def call
          Conditions::Evaluator.new(
            schema: items_schema,
            input: input,
            current_path: current_path,
            node_accessor: node_accessor,
            config: config,
            parent_node: self
          ).call

          apply_conditional_schemas
        end

        private

        def items_schema
          schema.fetch(:items, {})
        end
      end
    end
  end
end