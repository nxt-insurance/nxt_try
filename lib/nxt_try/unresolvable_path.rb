module NxtTry
  class UnresolvablePath
    def initialize(error)
      @error = error
    end

    def inspect
      "#{self.class.name}: #{@error}"
    end

    alias to_s inspect
  end
end
