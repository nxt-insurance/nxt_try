module NxtTry
  module Schema
    module Validators
      module Integer
        class Pattern
          def initialize(value, *args)
            @pattern = parse_pattern(args.first)
            @value = value
          end

          def call
            return if value.to_s.match(pattern)

            # TODO: This should be proper errors that allow for interpolation
            "Value: #{value} does not match pattern: #{pattern}"
          end

          private

          attr_reader :pattern, :value

          def parse_pattern(pattern)
            /#{pattern}/
          end
        end
      end
    end
  end
end