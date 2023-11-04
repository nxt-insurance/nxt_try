module NxtTry
  module Conditions
    module Evaluators
      class AllOf < Base
        def call
          apply_conditional_schemas

          schemas.each do |sub_schema|
            Conditions::Evaluator.new(
              schema: sub_schema,
              input: input,
              current_path: current_path,
              node_accessor: node_accessor,
              config: config
            ).call
          end
        end

        private

        def schemas
          schema.fetch(:type).fetch(:all_of)
        end
      end
    end
  end
end