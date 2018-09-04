var parser = require('./grammer.js')

try {
  var result = parser.parse('test:2 AND name:"adc" 11')
} catch (e) {
  console.log(e.name)
  console.log(e.message)
  console.log(e.location)
}