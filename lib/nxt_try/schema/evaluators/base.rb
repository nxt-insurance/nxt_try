module NxtTry
  module Schema
    module Evaluators
      class Base
        def initialize(schema:, input:, current_path:, node_accessor:, config:)
          @schema = schema
          @input = input
          @current_path = current_path
          @node_accessor = node_accessor
          @config = config
          @children = []
          @result = Schema::Evaluators::Result.new(current_path, schema)
        end

        attr_reader :schema, :input, :current_path, :node_accessor, :config, :children, :result

        def call
          raise NotImplementedError
        end

        def valid?
          @valid ||= begin
                       if children.any?
                         result.errors.empty? && children.all?(&:valid?)
                       else
                         result.errors.empty?
                       end
                     end
        end

        private

        attr_writer :children

        def coerce_input
          coercer.call(current_input)
        rescue => e
          add_error(e)
          current_input
        end

        def valid_input?
          coercer.valid?(current_input)
        end

        def coercer
          NxtTry::Schema::Evaluators::Coercers.resolve(type)
        end

        def type
          schema.fetch(:type)
        end

        def current_input
          value = current_path.inject(input) do |acc, location|
            acc.fetch(location)
          end

          if value.respond_to?(:keys)
            value.deep_symbolize_keys!
          end

          value
        end

        def add_error(message)
          result.add_error(message)
        end

        def run_validations
          return unless config.validate?
          return unless validations.present?

          validation_errors = NxtTry::Schema::Validator.new(
            expression: validations,
            node_type: type,
            input: current_input,
            node_accessor: node_accessor,
            config: config
          ).call

          validation_errors = validation_errors.compact
          validation_errors.each { |error| result.add_error(error) }

          validation_errors.any?
        end

        def validations
          @validations ||= schema.dig(:validations)
        end
      end
    end
  end
end