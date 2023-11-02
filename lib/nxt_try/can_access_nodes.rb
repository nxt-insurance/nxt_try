module NxtTry
  module CanAccessNodes
    def evaluate_path_or_value(path_or_value)
      path = PathIdentifier.new(path_or_value).call
      return path_or_value unless path

      node_accessor.call(path: path)
    end
  end
end