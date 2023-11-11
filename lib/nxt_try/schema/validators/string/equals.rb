module NxtTry
  module Schema
    module Validators
      module String
        class Equals
          def initialize(value, *args)
            @allowed = args.first
            @value = value
          end

          def call
            return if allowed == value

            {
              value: value,
              validator: self.class.name.demodulize.downcase,
              reference: allowed,
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