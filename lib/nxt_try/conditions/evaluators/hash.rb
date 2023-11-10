module NxtTry
  module Conditions
    module Evaluators
      class Hash < Base
        def call
          attributes.each do |key, value|
            path = current_path + [key]

            Conditions::Evaluator.new(
              schema: value,
              input: input,
              current_path: path,
              config: config,
              parent_node: self
            ).call
          end

          apply_conditional_schemas
        end

        private

        def attributes
          schema.fetch(:attributes, {})
        end
      end
    end
  end
end