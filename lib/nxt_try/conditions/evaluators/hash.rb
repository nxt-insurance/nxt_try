module NxtTry
  module Conditions
    module Evaluators
      class Hash < Base
        def call
          apply_conditional_schemas

          attributes.each do |key, value|
            path = current_path + [key]

            Conditions::Evaluator.new(
              schema: value,
              input: input,
              current_path: path,
              node_accessor: node_accessor,
              config: config
            ).call
          end
        end

        private

        def attributes
          schema.fetch(:attributes, {})
        end
      end
    end
  end
end