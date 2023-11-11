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

            {
              value: value,
              reference: allowed,
              validator: self.class.name.demodulize.downcase,
              message: "Value #{value} is not greater #{allowed}"
            }
          end

          private

          attr_reader :allowed, :value
        end
      end
    end
  end
end