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

      checks = (example.keys - %w[input schema])

      checks.each do |check|
        expectation_schema = File.read(example.fetch(check))

        puts "testing example #{index}"

        result = NxtTry::Evaluator.new(schema: schema).call(input)
        expectation = JSON.parse(expectation_schema, symbolize_names: true)
        expect(result.to_h).to send(check, expectation)
      end

    end
  end
end