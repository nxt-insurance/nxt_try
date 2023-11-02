module NxtTry
  module Schema
    module Validators
      module Logic
        class Registry
          include NxtRegistry::Singleton

          registry do
            register(:and, :And)
            register(:all_of, :And)
            register(:not, :Not)
            register(:or, :Or)
            register(:any_of, :Or)

            resolver ->(type) { "NxtTry::Schema::Validators::Logic::#{type}".constantize }
          end
        end
      end
    end
  end
end
