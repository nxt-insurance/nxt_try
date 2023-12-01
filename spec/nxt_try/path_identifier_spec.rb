require 'rspec'

describe 'NxtTry::PathIdentifier' do
  context 'when it is a context path' do
    let('string') { '~/' }

    it 'succeeds' do
      pending 'Not implemented'
    end
  end

  context 'when it is a relative path' do
    let('string') { './' }

    it 'succeeds' do
      pending 'Not implemented'
    end
  end

  context 'when the path goes up' do
    let('string') { '../../' }

    it 'succeeds' do
      pending 'Not implemented'
    end
  end

  context 'when the path is from the root' do
    let('string') { '/' }

    it 'succeeds' do
      pending 'Not implemented'
    end
  end
end