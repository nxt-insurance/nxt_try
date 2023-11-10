module NxtTry
  class NodeAccessor
    include TypeDefinitions
    PathNotResolvableError = Class.new(NxtTry::Error)

      def initialize(schema:, input:, config:, current_path:, parent_node:, node:)
      @input = input
      @config = config
      @schema = resolve_defined_type(schema)
      @current_path = current_path
      @parent_node = parent_node
      @node = node
    end

    attr_reader :schema, :input, :config, :current_path, :parent_node, :node

    # TODO: Do some memoization here?

    def call(path:)
      path = parse_path(path)

      if path.first.to_s == '~'
        extract_value(config.context, path[1..-1])
      else
        coerce_value_with_schema(path)
      end
    rescue PathNotResolvableError => e
      UnresolvablePath.new(e)
    end

    def schema_for_path(path)
      resolve_schemas_for_path(schema: root, current_path: path)
    end

    def coerce_value_with_schema(path)
      schema_or_schemas = schema_for_path(path)

      schemas = if schema_or_schemas.is_a?(Array)
        schema_or_schemas
      else
        [schema_or_schemas]
      end

      value = extract_value(input, path)

      # If there are multiple possible paths to the value (all_of, any_of)
      # we simply try to find one and use that as coercer
      evaluator = nil

      schemas.each do |schema|
        eval = NxtTry::Schema::Evaluator.new(
          config: config.clone_with_options({ validate: false }),
          schema: schema,
          input: value,
          current_path: []
        ).call

        if eval.valid?
          break evaluator = eval
        else
          next
        end
      end

      evaluator && evaluator.result.output
    end

    private

    def resolve_schemas_for_path(schema:, current_path:)
      schema = resolve_defined_type(schema)
      type = schema.fetch(:type)
      type = resolve_type_expression(type)

      case type
      when 'array'
        sub_schema = schema.fetch(:items)
        resolve_schemas_for_path(schema: sub_schema, current_path: current_path[1..-1])
      when 'hash'
        sub_schema = schema.fetch(:attributes).fetch(current_path.first)
        resolve_schemas_for_path(schema: sub_schema, current_path: current_path[1..-1])
      when 'all_of'
        sub_schemas = schema.fetch(:type).fetch(:all_of)
        sub_schemas.map do |sub_schema|
          resolve_schemas_for_path(schema: sub_schema, current_path: current_path)
        end
      when 'any_of'
        sub_schemas = schema.fetch(:type).fetch(:any_of)
        sub_schemas.map do |sub_schema|
          resolve_schemas_for_path(schema: sub_schema, current_path: current_path)
        end
      when 'string', 'string!', 'integer', 'boolean'
        schema
      else
        raise NotImplementedError, "Don't know how to resolve schema for type: #{type}"
      end
    end

    def extract_value(data, path)
      ValueExtractor.new(data: data, path: path).call
    end

    def parse_path(string)
      # TODO: Currently we only support path from the root!

      path_to_relative_path = if string.start_with?('./')
                                string = string.gsub(/\A\./, '')
                                current_path.dup
                              elsif string.start_with?('../')
                                parent_pattern = /\.\.\//
                                matches = string.scan(parent_pattern)
                                string = string.gsub(parent_pattern, '')
                                string = string.prepend('/')
                                current_path[0..-matches.size+1]
                              else
                                []
                              end

      parts = string.to_s.split('/').reject(&:blank?).inject([]) do |acc, part|
        # array access: path[0]
        match = part.match(/(\w+)(\[\d+\])/)
        if match
          acc + match.captures
        else
          acc + [part]
        end
      end

      (path_to_relative_path + parts).map(&:to_sym)
    end

    def resolve_type_expression(type)
      if type.is_a?(::Hash)
        type.keys.first.to_s
      else
        type
      end
    end

    def root
      @root ||= begin
                  gateway = self
                  root = schema

                  while gateway&.parent_node do
                    root = gateway.parent_node.schema
                    gateway = gateway.parent_node
                  end

                  root
                end
    end
  end
end