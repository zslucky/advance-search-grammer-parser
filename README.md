# advance-search-grammer-parser

A grammer parser for advance search
---

### Usage

```javascript
import { parse } from 'advance-search-grammer-parser'

const ast = parse('name: "a" and age: 18 and gender: 0 or name: not "b"')
```

### Grammer

Here are the all support grammers

#### Basic Usage

Expressions are consist of many `key:value` like words, So the basic grammer is:

```
[key]:[value] {(and|or) [key]:[value]}*

e.g.
name: "lucky" and age: 18 or name: "lucy"

// Group conditions
name: "lucky" and (age: 18 or name: "lucy")

// Reverse result
name: not "lucky"
```

#### Value Types

- `String` : `name: "lucky"` , wrapped by double quotation.
- `Float` : `height: 168.5` , `length: -2.2` .
- `Number` : `age: 18` .
- `Boolean` : `male: true` .
- `Function` : `user: current_user()` , `deadline: date("1y1m2d", 2, current_user())`
- Group:
  - `In` : `user: <"1", "2", current_user()>` .
  - `Contain` : `tag: |"red", "small"|` .
  - `Range` : `date: [ 150000000 TO 157000000 ]` , `date: { date("1y2m3d") TO 157000000 ]`