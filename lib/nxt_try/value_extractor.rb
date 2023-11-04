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
            raise PathNotResolvableError, "Could not resolve value for index: #{location} in: #{acc}"
          end

          if index > acc.length - 1
            raise PathNotResolvableError, "Index #{index} beyond size of #{acc.size}"
          else
            acc[index]
          end
        when ::Hash
          acc.fetch(location)
        else
          raise PathNotResolvableError, "Could not resolve path: #{path} in: #{input}"
        end
      end
    rescue KeyError
      raise PathNotResolvableError, "Could not resolve path: #{path} in: #{input}"
    end
  end
end
