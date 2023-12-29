module NxtTry
  module Dsl
    TYPE_CONTAINERS = Dry::Container.new

    def evaluator(with_types: nil, options: {})
      if with_types.present?
        types_container = TYPE_CONTAINERS.resolve(with_types)
        options = options.merge(defined_types: types_container)
      end

      -> (schema) { NxtTry::Evaluator.new(schema: schema, options: options) }
    end

    def register_types(name, types)
      container = build_type_registry(types)
      TYPE_CONTAINERS.register(name, container)
    end

    def build_type_registry(types)
      container = Dry::Container.new
      register_types_in_container(types, container)
      container
    end

    def register_types_in_container(types, container, namespace = [])
      types.symbolize_keys.each do |(key, value)|
        type = value.fetch(:type).to_s
        current_namespace = namespace + [key]

        if type == 'namespace'
          register_types_in_container(value.symbolize_keys.fetch(:definitions), container, current_namespace)
        else
          container.register(current_namespace.join('.'), value)
        end
      end
    end
  end
end