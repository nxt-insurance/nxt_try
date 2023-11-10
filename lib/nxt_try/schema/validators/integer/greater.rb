module NxtTry
  module Schema
    module Validators
      module Integer
        class Greater
          def initialize(value, *args)
            @allowed = args.first
            @value = value
          end

          def call
            return if value > allowed
            rescue

            # TODO: This should be proper errors that allow for interpolation
            "Value: #{value} is not greater: #{allowed}"
          end

          private

          attr_reader :allowed, :value
        end
      end
    end
  end
end