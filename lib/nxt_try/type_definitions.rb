module NxtTry
  module TypeDefinitions
    IDENTIFIER_PATTERN = /\A#/

    # Naming is not good since we mix schemas and types
    def schema_or_defined_schema(schema)
      if defined_type?(schema)
        defined_type(schema)
      else
        schema
      end
    end

    def defined_type(schema)
      key = schema.fetch(:type).gsub(IDENTIFIER_PATTERN, '')
      template_schema = NxtTry::TypeRegistry.resolve(key)
      template_schema.dup # make a copy of the template
    end

    def defined_type?(schema)
      type = schema.fetch(:type)
      return unless type.is_a?(String)
      schema.fetch(:type).match(IDENTIFIER_PATTERN)
    end
  end
end