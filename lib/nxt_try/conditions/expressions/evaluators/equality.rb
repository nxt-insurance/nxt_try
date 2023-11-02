module NxtTry
  module Conditions
    module Expressions
      module Evaluators
        class Equality
          def initialize(left, right)
            @left = left
            @right = right
          end

          def call
            left == right
          end

          private

          attr_reader :left, :right
        end
      end
    end
  end
end