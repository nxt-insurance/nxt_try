module NxtTry
  module Schema
    module Evaluators
      class Primitive < Evaluators::Base
        def call
          value = coerce_input
          result.output = value
          run_validations

          self
        end

        private

        def attributes
          schema.fetch(:attributes)
        end
      end
    end
  end
end