{
  /**
   * Parse the expression to standard definition object
   *
   * @param {object} head The head term object
   * @param {array} tail The follow terms array
   *
   * @returns {array} The exporession array
   */
  function getExpression(head, tail) {
    const expArray = [head]

    return tail.reduce((prev, cur) => ([
      ...prev,
      Array.isArray(cur) ?
      {
        logic: cur[1],
        value: cur[3],
      } :
      {
        logic: cur[1],
        field: cur[3].field,
        reverse: cur[3].reverse,
        value: cur[3].value,
      },
    ]), expArray)
  }

  /**
   * Parse the term to standard definition object
   *
   * @param {string} field The field name
   * @param {object} value The value object
   * @param {string} reverse The reverse keyword `not`
   *
   * @returns {object} The term definition object
   */
  function getTerm(field, value, reverse) {
    const needReverse = reverse ? true : false

    return { field, reverse: needReverse, value }
  }

  /**
   * Parse the variable name
   *
   * @param {array} name The variable matched name
   *
   * @returns {string} The variable name
   */
  function parseVariableName(name) {
    return name[0] + name[1].join('')
  }

  /**
   * Parse the number-like string array to standard definition object
   *
   * @param {array} num The matched number-like string array
   *
   * @returns {object} The number standard definition object
   */
  function parseNumber(num) {
    const realNum = num.join('')

    return { type: 'number', value: parseInt(realNum, 10) }
  }

  /**
   * Parse the string-like array to string
   *
   * @param {array} str The matched string-like array
   *
   * @returns {string} The string
   */
  function parseStringDefine(str) {
    return str.join('')
  }

  /**
   * Parse the string to standard definition object
   *
   * @desc star symbol can only be used either in start position or end position
   *
   * @param {string} str The matched string
   * @param {starHead} starHead The matched star `*` before the string
   * @param {starTail} starTail The matched star `*` behind the string
   *
   * @returns {object} The string standard definition object
   */
  function parseString(str, starHead, starTail) {
    const value = str || ''
    const starPrev = starHead || ''
    const starNext = starTail || ''

    return {
      type: 'string',
      value: starPrev + value + starNext,
    }
  }

  /**
   * Parse Function to standard definition object
   *
   * @param {string} name The function name
   * @param {string} params The function invoke params
   *
   * @returns {object} The function definition object
   */
  function parseFunction(name, params) {
    return { type: 'function', name, params }
  }

  /**
   * Parse the collection value to standard definition object list
   *
   * @param {string|number} head The head Factor
   * @param {array} tail The Factor array
   *
   * @returns {array} The standard definition value collection
   */
  function parseCollectionValue(head, tail) {
    const tailList = tail.reduce(
      (prev, cur) => ([ ...prev, cur[2] ]), []
    )

    return [].concat(head, tailList)
  }

  /**
   * Parse collection value with in logic to standard definition object
   *
   * @param {string|number} head The head Factor
   * @param {array} tail The Factor array
   *
   * @returns {array} The standard definition group in object
   */
  function parseGroupIn(head, tail) {
    const value = parseCollectionValue(head, tail)

    return { type: 'collection', logic: 'in', value }
  }

  /**
   * Parse collection value with contain logic to standard definition object
   *
   * @param {string|number} head The head Factor
   * @param {array} tail The Factor array
   *
   * @returns {array} The standard definition group contain object
   */
  function parseGroupContain(head, tail) {
    const value = parseCollectionValue(head, tail)

    return { type: 'collection', logic: 'contain', value }
  }

  /**
   * Parse range value to standard definition object
   *
   * @param {object} start The range start Factor
   * @param {object} end The range end Factor
   *
   * @returns {array} The standard definition range object
   */
  function parseGroupRange(start, end) {
    return { type: 'range', start, end }
  }
}

/**
 *  Entry
 */
Expression
  = _ head:(Term / Statement) tail:(__ (OPAnd / OPOr) __ (Term / Statement))* _
    { return getExpression(head, tail) }

Statement
  = LeftBracket exp:Expression RightBracket
    { return exp }

Term
  = field:Field _ Colon _ reverse:(OPNot __)? value:FieldValue
    { return getTerm(field, value, reverse) }

Factor
  = Number
  / String
  / Function

/**
 *  collection Definition
 */
GroupIn
  = LeftArrow _ head:Factor _ tail:("," _ Factor)* _ RightArrow
    { return parseGroupIn(head, tail) }
GroupContain
  = VerticalLine _ head:Factor _ tail:("," _ Factor)* _ VerticalLine
    { return parseGroupContain(head, tail) }
GroupRange
  = (LeftSquareBracket / LeftBrace) _ start:(Factor / Star) __ OPTo __ end:(Factor / Star) _ (RightSquareBracket / RightBrace)
    { return parseGroupRange(start, end) }

/**
 *  Logic operation Definition
 */
OPAnd
  = "AND" / "and" / "And"
OPOr
  = "OR" / "or" / "Or"
OPNot
  = "NOT" / "not" / "Not"
OPTo
  = "TO" / "to" / "To"

/**
 *  Sematic Symbol Definition
 */
_
  = [ \n\r\t]*
__
  = [ \n\r\t]+

Star
  = "*"
Wave
  = "~"
Colon
  = ":"

/**
 *  Group symbol Definition
 */
VerticalLine
  = "|"
LeftArrow
  = "<"
RightArrow
  = ">"

LeftBracket
  = "("
RightBracket
  = ")"

LeftSquareBracket
  = "["
RightSquareBracket
  = "]"

LeftBrace
  = "{"
RightBrace
  = "}"

/**
 *  Type Definition
 */
StringDefine
  = str:[^\t\n\r*"]*
    { return parseStringDefine(str) }
String
  = "\"" str:StringDefine? "\""
    { return parseString(str) }
  / "\"" starHead:Star? str:StringDefine? starTail:Star? "\""
    { return parseString(str, starHead, starTail) }

Number
  = num:([0-9]+)
    { return parseNumber(num) }
NumberWith0
  = num:[0-9]
    { return parseNumber(num) }
NumberWithout0
  = num:[1-9]
    { return parseNumber(num) }

VariableName
  = name:([a-zA-Z_][0-9a-zA-Z_]*)
    { return parseVariableName(name) }

FunctionParams
  = String
  / Number
FunctionInvoke
  = LeftBracket params:FunctionParams* RightBracket
    { return params }
Function
  = name:VariableName params:FunctionInvoke
    { return parseFunction(name, params) }

/**
 *  Field Definition
 */
Field
  = field:([a-zA-Z_][0-9a-zA-Z_.]*)
    { return parseVariableName(field) }

FieldValue
  = Factor
  / GroupIn
  / GroupContain
  / GroupRange

