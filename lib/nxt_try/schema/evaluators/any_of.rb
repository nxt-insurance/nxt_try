module NxtTry
  module Schema
    module Evaluators
      class AnyOf < Evaluators::Base
        def call
          evaluators = schemas.map do |sub_schema|
            Evaluator.new(
              schema: sub_schema,
              input: input,
              current_path: current_path,
              config: config,
              parent_node: self
            ).call
          end

          match = evaluators.find(&:valid?)

          if match
            children << match
            result.output = match.result.output
          else
            children << evaluators
            evaluators.each do |evaluator|
              evaluator.result.errors.each { |_, error| result.add_error(error, current_path) }
            end
            # When nothing matches we set the result to the first output which should be the input
            result.output = evaluators.first.result.output
          end

          self
        end

        private

        def schemas
          schemas = schema.fetch(:type).fetch(:any_of)
          return schemas unless config.filters.any?

          filtered_schemas = schemas.select { |schema| (Array(schema.fetch(:filters, [])) & config.filters).any? }
          return filtered_schemas if filtered_schemas.any?

          # We cannot have no schemas for an any_of node as we would not know how to coerce
          raise ArgumentError, "Applying the filters: #{config.filters} for #{current_path} resulted in empty any of node"
        end
      end
    end
  end
end