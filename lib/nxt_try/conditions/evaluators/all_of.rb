module NxtTry
  module Conditions
    module Evaluators
      class AllOf < Base
        def call
          schemas.each do |sub_schema|
            Conditions::Evaluator.new(
              schema: sub_schema,
              input: input,
              current_path: current_path,
              config: config,
              parent_node: self
            ).call
          end

          apply_conditional_schemas
        end

        private

        def schemas
          schema.fetch(:type).fetch(:all_of)
        end
      end
    end
  end
end