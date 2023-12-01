module NxtTry
  class ValueExtractor
    def initialize(path:, data:)
      @data = data
      @path = path
    end

    private attr_reader :path, :data

    def call
      path.inject(data) do |acc, location|
        case acc
        when ::Array
          # [index]
          match = location.to_s.match(/\[(\d+)\]/)

          if match
            index = Integer(match.captures.first)
          else
            raise NodeAccessor::PathNotResolvableError, "Could not resolve value for index: #{location} in: #{acc}"
          end

          if index > acc.length - 1
            raise NodeAccessor::PathNotResolvableError, "Index #{index} beyond size of #{acc.size}"
          else
            acc[index]
          end
        when ::Hash
          acc.fetch(location)
        else
          raise NodeAccessor::PathNotResolvableError, "Could not resolve path: #{path} in: #{data}"
        end
      end
    rescue KeyError
      raise NodeAccessor::PathNotResolvableError, "Could not resolve path: #{path} in: #{data}"
    end
  end
end
