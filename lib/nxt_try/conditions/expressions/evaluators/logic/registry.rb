module NxtTry
  module Conditions
    module Expressions
      module Evaluators
        module Logic
          class Registry
            include NxtRegistry::Singleton

            registry do
              register(:and, :And)
              register(:not, :Not)
              register(:or, :Or)

              resolver ->(type) { "NxtTry::Conditions::Expressions::Evaluators::Logic::#{type}".constantize }
            end
          end
        end
      end
    end
  end
end
