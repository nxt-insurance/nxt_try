module NxtTry
  module Schema
    module Validators
      module String
        class Length < Base
          def initialize(value, *args)
            @length = Integer(args.first)
            @value = value
          end

          def call
            if !value.respond_to?(:length)
              {
                value: value,
                reference: length,
                validator: self.class.name.demodulize.downcase,
                message: "Can't determine length of #{value}"
              }
            else
              if value.length != length
                {
                  value: value,
                  validator: self.class.name.demodulize.downcase,
                  reference: length,
                  message: "Value #{value} is not of length #{length}"
                }
              else
                return success
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