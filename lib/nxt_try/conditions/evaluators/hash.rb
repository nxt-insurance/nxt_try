module NxtTry
  module Conditions
    module Evaluators
      class Hash < Base
        def call
          attributes.each do |key, value|
            path = current_path + [key]

            puts "path: #{path}"
            Conditions::Evaluator.new(
              schema: value,
              input: input,
              current_path: path,
              node_accessor: node_accessor,
              config: config
            ).call

            apply_conditional_schemas
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