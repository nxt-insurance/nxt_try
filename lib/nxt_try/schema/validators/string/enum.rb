module NxtTry
  module Schema
    module Validators
      module String
        class Enum < Base
          def initialize(value, *args)
            @allowed = Array(args.first)
            @value = value
          end

          def call
            return success if allowed.include?(value)

            {
              value: value,
              validator: self.class.name.demodulize.downcase,
              reference: allowed,
              message: "Value #{value} not included in: #{allowed}"
            }
          end

          private

          attr_reader :allowed, :value
        end
      end
    end
  end
end
