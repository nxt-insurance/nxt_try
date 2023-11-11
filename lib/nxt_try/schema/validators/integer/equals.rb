module NxtTry
  module Schema
    module Validators
      module Integer
        class Equals
          def initialize(value, *args)
            @allowed = args.first
            @value = value
          end

          def call
            return if allowed == value

            {
              value: value,
              reference: allowed,
              validator: self.class.name.demodulize.downcase,
              message: "Value #{value} does not equal #{allowed}"
            }
          end

          private

          attr_reader :allowed, :value
        end
      end
    end
  end
end