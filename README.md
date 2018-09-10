# advance-search-grammer-parser

A grammer parser for advance search
---

### Dependenies
  - pegjs (0.10.0)

### Usage

```javascript
import parser from 'advance-search-grammer-parser'

const ast = parser.parse('name: "a" and age: 18 and gender: 0 or name: not "b"')
```
