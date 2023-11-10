module NxtTry
  module Schema
    module Validators
      module Hash
        class Length
          def initialize(value, *args)
            @length = Integer(args.first)
            @value = value
          end

          def call
            if !value.respond_to?(:length)
              "Can't resolve length of #{value}"
            else
              if value.length != length
                # TODO: This should be proper errors that allow for interpolation
                "Length of #{value} does not match #{length}"
              end
            end
          end

          private

          attr_reader :length, :value
        end
      end
    end
  end
end