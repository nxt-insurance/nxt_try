module NxtTry
  class Evaluator
    def initialize(schema:, input:, current_path: [], options: {})
      @schema = parse_json(schema)
      @input = parse_json(input)
      @current_path = current_path
      @config = build_config(options)
    end

    attr_reader :schema, :input, :current_path, :node_accessor, :config

    def call
      evaluate_conditions
      evaluation = evaluate_schema
      evaluation.result
    end

    def evaluate_conditions
      Conditions::Evaluator.new(
        schema: schema,
        input: input,
        current_path: current_path,
        node_accessor: nil,
        config: config
      ).call
    end

    def evaluate_schema
      Schema::Evaluator.new(
        config: config,
        schema: schema,
        input: input,
        current_path: current_path
      ).call
    end

    private

    def parse_json(json)
      json = json.to_json unless json.is_a?(String)
      JSON.parse(json, symbolize_names: true)
    end

    def build_config(options)
      Config.new(schema: schema, input: input, options: options)
    end
  end
end