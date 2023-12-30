module NxtTry
  module Schema
    module Validators
      module Hash
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
                  reference: length,
                  validator: self.class.name.demodulize.downcase,
                  message: "Value #{value} does not match length #{length}"
                }
              else
                success
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