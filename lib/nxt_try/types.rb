module NxtTry
  module Types
    include Dry.Types()

    PRIMITIVES = %w[string string! integer decimal boolean date_time date time null]
    HASHES = %w[hash hash! object object!]
    ARRAYS = %w[array array!]
    ALL = PRIMITIVES + HASHES + ARRAYS

    LengthyString = Types::Strict::String.constrained(min_size: 1)
    LengthyArray = Types::Strict::Array.constrained(min_size: 1)
    LengthyHash = Types::Strict::Hash.constrained(min_size: 1)
  end
end