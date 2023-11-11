module NxtTry
  module Schema
    module Validators
      module Array
        class Length
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
                  reference: length,
                  validator: self.class.name.demodulize.downcase,
                  message: "Value #{value} does not match length #{length}"
                }
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