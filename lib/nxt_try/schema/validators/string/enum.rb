module NxtTry
  module Schema
    module Validators
      module String
        class Enum
          def initialize(value, *args)
            @allowed = Array(args.first)
            @value = value
          end

          def call
            return if allowed.include?(value)

            # TODO: This should be proper errors that allow for interpolation
            "Value: #{value} does not match enum: #{allowed}"
          end

          private

          attr_reader :allowed, :value
        end
      end
    end
  end
end
