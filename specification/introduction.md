# Types
## hash
## array
## primitives
## all_of 
## any_of
## defined types
## namespaces
# Nodes
## Required Nodes
## Additional Nodes
### Allowed
### Restricted
## Conditional Nodes
### Paths
### Context
### if else
### case when else
# Validations
## Combinations
# Filters
# Constants [?]
Allow to define a constants by matching against a sub schemas?

```json
{
  "definitions": {
    "constants": {
      "buildings_premium": {
        "and": [
          { "/path/to/tariff_line": { "equals": "premium" } },
          { "/path/to/tariff_type": { "equals": "buildings" } }
        ]
      }
    }
  }
}
```