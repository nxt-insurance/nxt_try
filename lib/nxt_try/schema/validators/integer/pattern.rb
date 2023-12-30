module NxtTry
  module Schema
    module Validators
      module Integer
        class Pattern < Base
          def initialize(value, *args)
            @pattern = parse_pattern(args.first)
            @value = value
          end

          def call
            return success if value.to_s.match(pattern)

            {
              value: value,
              reference: pattern,
              validator: self.class.name.demodulize.downcase,
              message: "Value #{value} does not match #{pattern}"
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