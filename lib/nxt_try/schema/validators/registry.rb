module NxtTry
  module Schema
    module Validators
      class Registry
        include NxtRegistry::Singleton

        registry do
          # Somehow nxt_registry does not allow :hash as key and this is a hack to get around this
          transform_keys ->(key) { key.to_s.upcase.to_sym }

          registry(:String) do
            register(:pattern, 'Pattern')
            register(:enum, 'Enum')
            register(:length, 'Length')
            register(:size, 'Length')
            register(:equals, 'Equals')

            resolver ->(validator) { "NxtTry::Schema::Validators::String::#{validator}".constantize }
          end

          registry(:Integer) do
            register(:equals, 'Equals')
            register(:greater, 'Greater')
            register(:>, 'Greater')
            register(:pattern, 'Pattern')

            resolver ->(validator) { "NxtTry::Schema::Validators::Integer::#{validator}".constantize }
          end

          registry(:Array) do
            register(:length, 'Length')
            register(:min_length, 'MinLength')
            register(:min_size, 'MinLength')
            register(:max_length, 'MaxLength')
            register(:max_size, 'MaxLength')

            resolver ->(validator) { "NxtTry::Schema::Validators::Array::#{validator}".constantize }
          end

          registry(:Hash) do
            register(:length, 'Length')
            # register(:min_length, 'MinLength')
            # register(:max_length, 'MaxLength')

            resolver ->(validator) { "NxtTry::Schema::Validators::Hash::#{validator}".constantize }
          end

          registry(:Date) do
            register(:greater, 'Greater')
            register(:>, 'Greater')
            register(:greater_or_equals, 'GreaterOrEquals')
            register(:>=, 'GreaterOrEquals')
            # register(:min_length, 'MinLength')
            # register(:max_length, 'MaxLength')

            resolver ->(validator) { "NxtTry::Schema::Validators::Date::#{validator}".constantize }
          end
        end
      end
    end
  end
end