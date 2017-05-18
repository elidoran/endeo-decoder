assert = require 'assert'
B = require '@endeo/bytes'

module.exports = (node, sign, bytes, control) ->

  # setup context with input buffer with the desired byte
  # NOTE: yeah, i'm reimplementing Input's functions...
  context =
    sign  : sign
    buffer: Buffer.from bytes
    index: 0
    hasByte: -> @index < @buffer.length
    hasBytes: (n) -> @index + n <= @buffer.length
    byte :     -> @buffer[@index++]
    short:     ->
      result = @buffer.readUInt16BE @index, true
      @index += 2
      result
    int  : (n) ->
      result = @buffer.readUIntBE @index, n, true
      @index += n
      result

  # run it with context
  node.call context, control
  
  return context
