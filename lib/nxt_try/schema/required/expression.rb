module NxtTry
  module Schema
    module Required
      class Expression
        def initialize(raw)
          @raw = raw

          @left = raw.keys.first
          @right = raw.values.first

          @type = parse_type
        end

        attr_reader :type, :left, :right, :type, :raw

        def evaluator
          return logic_evaluator if logic?
          required_evaluator
        end

        def logic?
          logic_evaluator.present?
        end

        def required?
          required_evaluator.present?
        end

        private

        # TODO: Make sure that keys cannot conflict!
        def parse_type
          if logic?
            'logic'
          elsif required?
            'requirement'
          else
            raise ArgumentError, "Could not resolve type of expression: #{raw}"
          end
        end

        def logic_evaluator
          @logic_evaluator ||= NxtTry::Schema::Required::Logic::Registry.resolve(left)
        end

        def required_evaluator
          @required_evaluator ||= NxtTry::Schema::Required::Evaluators::Registry.resolve(right.keys.first)
        end
      end
    end
  end
end
