module NxtTry
  module Schema
    module Evaluators
      class Base
        def initialize(schema:, input:, current_path:, config:, parent_node:)
          @schema = schema
          @input = input
          @current_path = current_path
          @config = config
          @children = []
          @result = Schema::Evaluators::Result.new(current_path, schema)
          @parent_node = parent_node
        end

        attr_reader :schema, :input, :current_path, :config, :children, :result, :parent_node

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

        def node_accessor
          @node_accessor ||= NodeAccessor.new(self)
        end

        def coerce_input
          coercer.call(current_input)
        rescue => e
          if e.is_a?(Dry::Types::CoercionError)
            add_error(
              {
                value: current_input,
                reference: type,
                validator: 'type',
                message: "Could not coerce value into a #{type}"
              }
            )
          else
            add_error(
              {
                value: current_input,
                reference: type,
                validator: 'type',
                message: e.message
              }
            )
          end

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

          validation_errors.each { |error| result.add_error(error) }
          validation_errors.any?
        end

        def validations
          @validations ||= schema.dig(:validations)
        end

        def node_name
          current_path.any? ? current_path.join('.') : 'root'
        end
      end
    end
  end
end