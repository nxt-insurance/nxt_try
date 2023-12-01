# NxtTry

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/nxt_try`. To experiment with that code, run `bin/console` for an interactive prompt.

- Types
  - any of, all of, none of, not
  - references by id
  - definitions
- Nodes
  - additional nodes strategy
  - required nodes strategy
- Contexts
  - in validations on any level 
  - in conditions on any level
- Conditions
  - conditional attributes
  - access values of nodes
  - logical expressions
  - merge strategy? 
  - does it make sense to remove conditions once evaluated?
  ```ruby
    {
      if: { and: [or: [{ equals: '~/path/to/context'}, {'~/path/to/context': 'other'}]] }, 
      then: { replace: { attributes: { ... }, validate: '' }, merge: { ... }  }, 
      else: { merge: { } } 
    }
  ```
  - NO nested conditions
- Validations
  - should be able to take any amount of args
  - logical expressions
    - and, or, not, xor
  ```ruby
    {
      validate: { and: [{ equals: '12345' }, { or: [{equals: 'qw'}, {not: 'ads'}]}],
      validate: { '~/path/to/context': [{ '/path/to/validation': '12345' }, { size: 5}]},
      validate: { '>=': 5 },
      validate: { 'api': { } },
      validate: { 'greater': 5 },
      validate: { 'between': [1, '~path/to/context'] },
      # maybe better named arguments
      validate: { 'between': { lower: 1, upper: '~path/to/context' } }
      # conditionals do not make sense and should be solved on schema level
      # validate: { if: {}, then: {}, else: {} }
    }
  ```
  - NO conditions in validations as those are on schema level
- Filters
- Proper type systems with namespacing
- Required nodes, omittable nodes 
- Should we allow conditions on all nodes or just hashes?
  - Why not all nodes?  
- Rethink merge and replace strategy
- Do not mutate original schema
  - Reference original schema 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nxt_try'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install nxt_try

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/nxt_try.
