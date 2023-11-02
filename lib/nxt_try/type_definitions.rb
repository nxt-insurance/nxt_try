module NxtTry
  module TypeDefinitions
    IDENTIFIER_PATTERN = /\A#/

    def resolve_defined_type(schema)
      if defined_type?(schema)
        defined_type(schema)
      else
        schema
      end
    end

    def defined_type(schema)
      key = schema.fetch(:type).gsub(IDENTIFIER_PATTERN, '')
      config.type_definitions.fetch(key.to_sym)
    end

    def defined_type?(schema)
      type = schema.fetch(:type)
      return unless type.is_a?(String)
      schema.fetch(:type).match(IDENTIFIER_PATTERN)
    end
  end
end