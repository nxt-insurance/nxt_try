module NxtTry
  module Schema
    module Evaluators
      class Hash < Evaluators::Base
        include CanAccessNodes

        def call
          # TODO: Allow hashes without attributes
          # Make sure we are dealing with a hash first
          if valid_input? && attributes_schema_provided?
            result.output = {}
            handle_additional_keys(result.output)
            missing_key_errors = []

            filtered_attributes.inject(missing_key_errors) do |acc, (key, sub_schema)|
              path = current_path + [key]

              if missing_required_node?(key, sub_schema)
                acc << key
              elsif missing_optional_node?(key, sub_schema)
                acc
              else
                evaluator = Evaluator.new(
                  schema: sub_schema,
                  input: input,
                  current_path: path,
                  config: config,
                  parent_node: self
                ).call

                children << evaluator
                evaluator.result.errors.each { |_, error| result.add_error(error, path) }
                result.output[key] = evaluator.result.output
              end

              acc
            end

            if missing_key_errors.any?
              add_error(
                value: input,
                reference: allowed_keys, # TODO: Not sure if reference is ideal
                message: "#{node_name} is missing keys #{missing_key_errors}",
                validator: 'keys'
              )
            end

            run_validations
          elsif valid_input? && !attributes_schema_provided?
            result.output = current_input
            coerce_input
            run_validations
          else
            result.output = current_input
            coerce_input
          end

          self
        end

        private

        def missing_optional_node?(key, sub_schema)
          missing_key?(key) && !required_node?(key, sub_schema)
        end

        def missing_required_node?(key, sub_schema)
          missing_key?(key) && required_node?(key, sub_schema)
        end

        def required_node?(key, sub_schema)
          @required_node ||= {}
          @required_node[key] ||= begin
                                    required = sub_schema.fetch(:required, true)

                                    if required.is_a?(::Hash)
                                      evaluate_expression(required)
                                    else
                                      required
                                    end
                                  end
        end

        def handle_additional_keys(current_node)
          return unless additional_keys?

          case additional_keys_strategy
          when 'allow'
            additional_keys.each do |key|
              current_node[key] = current_input[key]
            end
          when 'reject'
            # nothing to do
          when 'restrict'
            additional_keys.each do |key|
              current_node[key] = current_input[key]
            end

            add_error(
              value: input,
              reference: allowed_keys,
              message: "#{node_name} contains additional keys #{additional_keys}",
              validator: 'keys'
            )
          else
            raise ArgumentError, "Unknown strategy #{additional_keys_strategy}"
          end
        end

        def missing_key?(key)
          missing_keys.include?(key)
        end

        def missing_keys?
          missing_keys.any?
        end

        def missing_keys
          filtered_attributes.keys - current_input.keys
        end

        def additional_keys_strategy
          config.additional_keys_strategy
        end

        def additional_keys?
          additional_keys.any?
        end

        def additional_keys
          @additional_keys ||= current_input.keys - allowed_keys
        end

        def allowed_keys
          @allowed_keys ||= filtered_attributes.keys
        end

        def filtered_attributes
          @filtered_attributes||= begin
                                    filters = config.filters
                                    return attributes unless filters.any?

                                    attributes.inject({}) do |acc, (key,sub_schema)|
                                      current_filters = Array(sub_schema.fetch(:filters, []))

                                      if (current_filters & filters).any?
                                        acc[key] = sub_schema
                                        acc
                                      else
                                        acc
                                      end
                                    end
                                  end
        end

        def attributes_schema_provided?
          !attributes.is_a?(Undefined)
        end

        def attributes
          schema.fetch(:attributes, Undefined.new)
        end

        def evaluate_expression(expression)
          Required::Evaluator.new(
            expression: expression,
            input: input,
            node_accessor: node_accessor,
            config: config
          ).call
        end
      end
    end
  end
end