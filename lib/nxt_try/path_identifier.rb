module NxtTry
  class PathIdentifier
    KEYS = %w[/ ~ ./]

    def initialize(string)
      @string = string
    end

    def call
      path?(string)
    end

    private

    attr_reader :string

    def path?(string)
      string = String(string)
      matching_key = KEYS.find { |key| string.match?(key) }

      return false unless matching_key

      pattern = pattern(matching_key)
      string.gsub!(pattern, '')

      if string.match(pattern)
        false # when pattern still matches after gsub it's no path!
      else
        string
      end
    end

    def pattern(key)
      /\A#{key}\s+/
    end
  end
end