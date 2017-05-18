# the scale values for shifting ints back to their actual values
shift = require './ints-shift'

# for handling the bytes above the 6th
# because buffer.readIntBE() handles 1-6 bytes
POW6 = Math.pow 2, 48

# these are the stating nodes which don't depend on other nodes
# so they aren't wrapped in an initializer.
# this also means they're generall small functions,
# so, they're all in this file.
module.exports =

  specialDefaults: (control) ->

    if @integer?

      @specIndex += @integer
      @integer = null
      control.next()

    else control.fail 'specialDefaults requires integer'


  key: (control) ->

    if @$string?
      # take the string as a key.
      @key = @$string
      @$string = null
      control.next()
    else control.fail 'missing string for object key'
    return


  stringId: (control) ->
    if @integer?
      # take the integer as a stringId.
      @stringId = @integer
      @integer = null
      control.next()
    else control.fail 'missing integer for stringId'
    return


  toString: (control) ->

    if @integer?

      if @hasBytes @integer

        # store the string from @int number of bytes
        @$string = @string @integer
        @index += @integer
        @integer = null
        control.next()

      else control.wait 'wait in toString'

    else control.fail 'toString requires integer'
    return


  restring: (control) ->

    if @integer?

      @$string = @unstring.restring @integer
      @integer = null

      if @$string? then control.next()
      else control.fail 'restring failed: ' + @integer, id: @integer

    else control.fail 'missing integer for restring'
    return


  learn: (control) ->

    unless @stringId then return control.fail 'missing stringId for learn'
    unless @$string  then return control.fail 'missing string for learn'

    @unstring.learn @stringId, @$string
    @stringId = null
    @$string  = null

    control.next()
    return


  toBuffer: (control) ->

    if @integer?

      if @hasBytes @integer

        # store the string from @integer number of bytes
        # @bytes ? @binary? right into @value ?
        @value = @buffer.slice @index, @index + @integer
        @index += @integer
        @integer = null
        control.next()

      else control.wait 'wait in toBuffer'

    else control.fail 'toBuffer requires integer'
    return


  int1: (control) ->

    if @hasByte()

      @integer = @sign * (@byte() + shift.b1)
      control.next()

    else control.wait 'wait in int1'
    return


  int2: (control) ->

    if @hasBytes 2

      @integer = @sign * (@short() + shift.b2)
      control.next()

    else control.wait 'wait in int2'
    return


  int3: (control) ->

    if @hasBytes 3

      @integer = @sign * (@int(3) + shift.b3)
      control.next()

    else control.wait 'wait in int3'
    return


  int4: (control) ->

    if @hasBytes 4

      @integer = @sign * (@int(4) + shift.b4)
      control.next()

    else control.wait 'wait in int4'
    return


  int5: (control) ->

    if @hasBytes 5

      @integer = @sign * (@int(5) + shift.b5)
      control.next()

    else control.wait 'wait in int5'
    return


  int6: (control) ->

    if @hasBytes 6

      @integer = @sign * (@int(6) + shift.b6)
      control.next()

    else control.wait 'wait in int6'
    return


  int7: (control) ->

    if @hasBytes 7

      @integer = @sign * (@byte() * POW6 + @int 6)
      control.next()

    else control.wait 'wait in int7'
    return


  int8: (control) ->

    if @hasBytes 8

      @integer = @sign * (@short() * POW6 + @int 6)
      control.next()

    else control.wait 'wait in int8'
    return


  float4: (control) ->

    if @hasBytes 4

      @value = @float4()
      control.next()

    else control.wait 'wait in float4'
    return


  float8: (control) ->

    if @hasBytes 8

      @value = @float8()
      control.next()

    else control.wait 'wait in float8'
    return
