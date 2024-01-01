module NxtTry
  module CanAccessNodes
    def evaluate_path_or_value(path_or_value)
      path = PathIdentifier.new(path_or_value).call
      return path_or_value unless path

      node_accessor.call(path: path)
    end

    def evaluate_path(path)
      path = PathIdentifier.new(path).call

      if path.present?
        node_accessor.call(path: path)
      else
        raise ArgumentError, "'#{path}' does not seem to be a path"
      end
    end
  end
end