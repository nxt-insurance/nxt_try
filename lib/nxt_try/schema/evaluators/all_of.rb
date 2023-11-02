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
              node_accessor: node_accessor,
              config: config
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
          schema.fetch(:type).fetch(:all_of)
        end
      end
    end
  end
end