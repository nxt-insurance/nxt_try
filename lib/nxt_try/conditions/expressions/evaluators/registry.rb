module NxtTry
  module Conditions
    module Expressions
      module Evaluators
        class Registry
          include NxtRegistry::Singleton

          registry do
            register(:equals, :Equality)

            resolver ->(type) { "NxtTry::Conditions::Expressions::Evaluators::#{type}".constantize }
          end
        end
      end
    end
  end
end
