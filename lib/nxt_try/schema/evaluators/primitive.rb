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
      end
    end
  end
end