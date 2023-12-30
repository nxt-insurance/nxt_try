# frozen_string_literal: true

require 'active_support/all'
require 'dry-types'
require 'dry-container'
require 'nxt_registry'

require_relative "nxt_try/version"
require_relative "nxt_try/error"
require_relative "nxt_try/config"
require_relative "nxt_try/types"
require_relative "nxt_try/dsl"
require_relative "nxt_try/type_definitions"
require_relative "nxt_try/path_identifier"
require_relative "nxt_try/node_accessor"
require_relative "nxt_try/unresolvable_path"
require_relative "nxt_try/undefined"
require_relative "nxt_try/can_access_nodes"
require_relative "nxt_try/value_extractor"
require_relative "nxt_try/evaluator"

require_relative "nxt_try/conditions/expression"
require_relative "nxt_try/conditions/expressions/case_when_statement"
require_relative "nxt_try/conditions/expressions/if_else_statement"
require_relative "nxt_try/conditions/expressions/evaluator"
require_relative "nxt_try/conditions/expressions/evaluators/registry"
require_relative "nxt_try/conditions/expressions/evaluators/equality"
require_relative "nxt_try/conditions/expressions/evaluators/logic/registry"
require_relative "nxt_try/conditions/expressions/evaluators/logic/and"
require_relative "nxt_try/conditions/evaluator"
require_relative "nxt_try/conditions/evaluators/base"
require_relative "nxt_try/conditions/evaluators/any_of"
require_relative "nxt_try/conditions/evaluators/all_of"
require_relative "nxt_try/conditions/evaluators/primitive"
require_relative "nxt_try/conditions/evaluators/hash"
require_relative "nxt_try/conditions/evaluators/array"

require_relative "nxt_try/schema/evaluators/result"
require_relative "nxt_try/schema/evaluators/coercers"
require_relative "nxt_try/schema/evaluators/base"
require_relative "nxt_try/schema/evaluators/any_of"
require_relative "nxt_try/schema/evaluators/all_of"
require_relative "nxt_try/schema/evaluators/hash"
require_relative "nxt_try/schema/evaluators/array"
require_relative "nxt_try/schema/evaluators/primitive"
require_relative "nxt_try/schema/evaluator"

require_relative "nxt_try/schema/required/evaluator"
require_relative "nxt_try/schema/required/evaluators/registry"
require_relative "nxt_try/schema/required/expression"
require_relative "nxt_try/schema/required/evaluators/traceable"
require_relative "nxt_try/schema/required/evaluators/equals"
require_relative "nxt_try/schema/required/logic/registry"
require_relative "nxt_try/schema/required/logic/base"
require_relative "nxt_try/schema/required/logic/and"

require_relative "nxt_try/schema/validator"
require_relative "nxt_try/schema/validators/success"
require_relative "nxt_try/schema/validators/base"
require_relative "nxt_try/schema/validators/registry"
require_relative "nxt_try/schema/validators/expression"

require_relative "nxt_try/schema/validators/logic/registry"
require_relative "nxt_try/schema/validators/logic/base"
require_relative "nxt_try/schema/validators/logic/and"
require_relative "nxt_try/schema/validators/logic/or"

require_relative "nxt_try/schema/validators/string/length"
require_relative "nxt_try/schema/validators/string/equals"
require_relative "nxt_try/schema/validators/string/enum"
require_relative "nxt_try/schema/validators/string/pattern"

require_relative "nxt_try/schema/validators/integer/equals"
require_relative "nxt_try/schema/validators/integer/greater"
require_relative "nxt_try/schema/validators/integer/pattern"

require_relative "nxt_try/schema/validators/array/length"
require_relative "nxt_try/schema/validators/hash/length"

module NxtTry
  extend Dsl
end

