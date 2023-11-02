module NxtTry
  module Conditions
    module Evaluators
      class Primitive < Base
        def call
          apply_conditional_schemas
        end
      end
    end
  end
end