module NxtTry
  module Schema
    module Evaluators
      class AllOf < Evaluators::Base
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

          self.children = evaluators
          all_valid = evaluators.all?(&:valid?)

          if all_valid
            result.output = evaluators.first.result.output
          else
            evaluators.reject(&:valid?).each do |evaluator|
              evaluator.result.errors.each { |_, error| result.add_error(error, current_path) }
            end
          end

          self
        end

        private

        def schemas
          schemas = schema.fetch(:type).fetch(:all_of)
          return schemas unless config.filters.any?

          filtered_schemas = schemas.select { |schema| (Array(schema.fetch(:filters, [])) & config.filters).any? }
          return filtered_schemas if filtered_schemas.any?

          # We cannot have no schemas for an any_of node as we would not know how to coerce
          raise ArgumentError, "Applying the filters: #{config.filters} for #{current_path} resulted in empty all of node"
        end
      end
    end
  end
end