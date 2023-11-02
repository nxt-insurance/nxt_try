module NxtTry
  module Schema
    module Validators
      class Expression
        def initialize(raw, node_type)
          @raw = raw
          @node_type = node_type

          @left = raw.keys.first
          @right = raw.values.first

          @type = parse_type
        end

        attr_reader :type, :node_type, :left, :right, :type, :raw

        def evaluator
          return logic_evaluator if logic?
          validation_evaluator
        end

        def logic?
          logic_evaluator.present?
        end

        def validation?
          validation_evaluator.present?
        end

        private

        # TODO: Make sure that keys cannot conflict!
        def parse_type
          if logic?
            'logic'
          elsif validation?
            'validation'
          else
            raise ArgumentError, "Could not resolve type of expression: #{raw}"
          end
        end

        def logic_evaluator
          @logic_evaluator ||= NxtTry::Schema::Validators::Logic::Registry.resolve(left)
        end

        def validation_evaluator
          @validation_evaluator ||= NxtTry::Schema::Validators::Registry.resolve(
            normalize_node_type,
            left
          )
        end

        def normalize_node_type
          @node_type_without_bang = node_type.gsub(/!\z/, '').downcase.to_sym
        end
      end
    end
  end
end