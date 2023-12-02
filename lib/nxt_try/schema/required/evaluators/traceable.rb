module NxtTry
  module Schema
    module Required
      module Evaluators
        class Traceable
          def initialize(value, presence_expectation)
            @value = value
            @presence_expectation = presence_expectation.is_a?(UnresolvablePath) ? false : presence_expectation
          end

          def call
            # TODO: Make sure presence expectation is boolean value
            if presence_expectation
              value && !value.is_a?(UnresolvablePath)
            else
              value.is_a?(UnresolvablePath)
            end
          end

          private

          attr_reader :value, :presence_expectation
        end
      end
    end
  end
end