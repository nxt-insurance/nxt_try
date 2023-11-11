module NxtTry
  module Schema
    module Validators
      module String
        class Pattern
          def initialize(value, *args)
            @pattern = parse_pattern(args.first)
            @value = value
          end

          def call
            return if value.to_s.match(pattern)

            {
              value: value,
              validator: self.class.name.demodulize.downcase,
              reference: pattern,
              message: "Value #{value} is not match #{pattern}"
            }
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