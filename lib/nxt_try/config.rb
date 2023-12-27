module NxtTry
  class Config
    def initialize(schema:, input:, options:)
      @schema = schema
      @original_schema = schema.deep_dup
      @input = input
      @options = build_options(options)
    end

    attr_reader :schema, :input, :original_schema, :options

    def defined_types
      @defined_types ||= options.fetch(:defined_types, nil)
    end

    def defined_types?
      defined_types.present?
    end

    def additional_keys_strategy
      @additional_keys_strategy ||= options.fetch(:additional_keys_strategy)
    end

    def filters
      @filters ||= Array(options.fetch(:filters, []))
    end

    def context
      @context ||= options.fetch(:context)
    end

    def validate?
      @validate ||= options.fetch(:validate)
    end

    # TODO: What's this for?
    def clone_with_options(opts)
      self.class.new(schema: schema, input: input, options: options.merge(opts))
    end

    private

    def build_options(opts)
      default_options.merge(opts)
    end

    def default_options
      {
        validate: true,
        additional_keys_strategy: 'reject', # reject, allow, restrict # TODO: Would ne nice to be able to set this per node
        filters: [],
        key_transformer: 'underscore' # TODO: underscore, camel_case, snake_case
      }
    end
  end
end