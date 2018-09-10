const { parse } = require('../dist/grammer.js')

const content = 'name: not "abc" and value: 223'

try {
  console.log(parse(content))
} catch (err) {
  console.log(err)
}

