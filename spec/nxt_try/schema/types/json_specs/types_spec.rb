RSpec.describe 'types' do

  let(:directories) { Dir["#{__dir__}/**/"] }

  let(:folders) { directories.select { |dir| Pathname.new(dir).children.all?(&:file?) } }

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
    examples.each_with_index do |example, index|
      schema = File.read(example.fetch('schema'))
      input = File.read(example.fetch('input'))
      expectation = File.read(example.fetch('expect'))

      puts "testing example #{index}"

      result = NxtTry::Evaluator.new(schema: schema, input: input).call
      expect(result.to_h).to eq(JSON.parse(expectation, symbolize_names: true))
    end
  end
end