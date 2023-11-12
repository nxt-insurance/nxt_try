module NxtTry
  module Schema
    module Evaluators
      class Result
        def initialize(path, schema)
          @path = path
          @schema = schema
          @output = nil
          @errors = {}
        end

        attr_accessor :output, :errors, :path, :schema

        def add_error(error, p = path)
          key = if p == []
            'root'
          else
            p.join('.')
          end

          errors[key] ||= []
          error = [error] if error.is_a?(::Hash)
          errors[key] += error
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

        def error_messages
          @error_messages ||= errors.inject({}) { |acc, (k,v)|
            acc[k] = v.map { |e| e.fetch(:message) }
            acc
          }
        end
      end
    end
  end
end