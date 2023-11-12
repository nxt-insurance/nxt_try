module NxtTry
  module Schema
    module Required
      module Logic
        class Registry
          include NxtRegistry::Singleton

          registry do
            register(:and, :And)
            register(:not, :Not)
            register(:or, :Or)

            resolver ->(type) { "NxtTry::Schema::Required::Logic::#{type}".constantize }
          end
        end
      end
    end
  end
end
