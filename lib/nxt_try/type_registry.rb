module NxtTry
  class TypeRegistry
    include Dry::Container::Mixin

    def load_types(types, namespace = [])
      types.symbolize_keys.each do |(key, value)|
        type = value.fetch(:type).to_s
        current_namespace = namespace + [key]

        if type == 'namespace'
          load_types(value.symbolize_keys.fetch(:definitions), current_namespace)
        else
          register(current_namespace.join('.'), value)
        end
      end
    end
  end
end