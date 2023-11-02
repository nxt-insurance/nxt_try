module NxtTry
  module Schema
    module Evaluators
      class Result
        def initialize(path)
          @path = path
          @output = nil
          @errors = {}
        end

        attr_accessor :output, :errors, :path

        def add_error(error, p = path)
          key = if p == []
            'root'
          else
            p.join('.')
          end

          errors[key] ||= []
          errors[key] += Array(error)
        end

        def to_h
          {
            errors: errors,
            output: output
          }
        end

        def valid?
          errors.empty?
        end
      end
    end
  end
end