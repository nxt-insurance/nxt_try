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
              node_accessor: node_accessor,
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
          end

          self
        end

        private

        def schemas
          schema.fetch(:type).fetch(:any_of)
        end
      end
    end
  end
end