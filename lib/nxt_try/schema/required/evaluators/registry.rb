module NxtTry
  module Schema
    module Required
      module Evaluators
        class Registry
          include NxtRegistry::Singleton

          registry do
            register(:equals, :Equals)
            register(:traceable, :Traceable)

            resolver ->(type) { "NxtTry::Schema::Required::Evaluators::#{type}".constantize }
          end
        end
      end
    end
  end
end
