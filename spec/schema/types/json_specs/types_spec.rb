RSpec.describe 'types' do

  let(:directories) { Dir["#{__dir__}/*/"] }

  let(:folders) do
    directories.select { |dir| Pathname.new(dir).children.all?(&:file?) }
  end

  let(:examples) do
    folders.inject([]) do |acc, folder|
      params = Pathname.new(folder).children
      example = { }
      params.each { |param| example[param.basename.to_s.split('.').first] = param.to_s }
      acc << example
      acc
    end
  end

  it do
    examples.each do |example|
      schema = File.read(example.fetch('schema'))
      input = File.read(example.fetch('input'))
      expectation = File.read(example.fetch('expect'))

      result = NxtTry::Evaluator.new(schema: schema, input: input).call
      expect(result.output).to eq(JSON.parse(expectation, symbolize_names: true))
    end
  end
end