module NxtTry
  module Schema
    module Evaluators
      class Coercers
        include NxtRegistry::Singleton

        registry call: false, required_keys: NxtTry::Types::ALL do
          register(:hash, NxtTry::Types::Strict::Hash)
          register(:object, NxtTry::Types::Strict::Hash)
          register(:hash!, NxtTry::Types::LengthyHash)
          register(:array, NxtTry::Types::Strict::Array)
          register(:array!, NxtTry::Types::LengthyArray)
          register(:string, NxtTry::Types::Strict::String)
          register(:string!, NxtTry::Types::LengthyString)
          register(:integer, NxtTry::Types::Strict::Integer)
          register(:boolean, NxtTry::Types::Strict::Bool)
          register(:date_time, Types::JSON::DateTime)
          register(:time, Types::JSON::Time)
          register(:date, Types::JSON::Date)
          register(:null, Types::JSON::Nil)
        end
      end
    end
  end
end