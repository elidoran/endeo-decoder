shift = require '../ints-shift'
POW6 = Math.pow 2, 48
NEG_POW6 = -POW6

# node 'value'
# coffeelint: disable=cyclomatic_complexity
module.exports = (control, N) ->

    unless @hasByte() then return control.wait 'wait in value'

    # get any kind of value for: object property or array element

    # look at the first byte to decide which node we go to

    # check range before switch
    byte = @byte()

    if byte <= @B.MAX_POS
      @value = byte
      control.next()

    else if byte <= @B.MAX_NEG
      @value = -1 * (byte - @B.MAX_POS)
      control.next()

    # now check exact matches
    else switch byte

      # then it's an extended ID, 'int' gets the ID, then on to `specialStart
      # TODO: could get the "spec" here and then go to 'special' ...
      when @B.SPECIAL then control.next N.int, N.specialStart

      # try to do the work now if we have the bytes, otherwise, use nodes
      when @B.OBJECT

        if @hasByte()

          switch @peek()

            when @B.SUB_TERMINATOR
              @eat()
              @value = {}
              control.next()

            when @B.TERMINATOR
              @eat()
              @value = {}
              control.next N.start

            else
              @pushObject()
              control.next N.string, N.key, N.value, N.assign

        else control.next N.generic

      # try to do the work now if we have the bytes, otherwise, use nodes
      when @B.ARRAY

        if @hasByte()

          switch @peek()

            when @B.SUB_TERMINATOR
              @eat()
              @value = []
              control.next()

            when @B.TERMINATOR
              @eat()
              @value = []
              control.next N.start

            else
              @pushArray()
              control.next N.value, N.push

        else control.next N.array

      when @B.STRING then control.next N.string, N.stringT

      when @B.TRUE then @value = true ; control.next()

      when @B.FALSE then @value = false ; control.next()

      when @B.NULL then @value = null ; control.next()

      when @B.EMPTY_OBJECT then @value = {} ; control.next()

      when @B.EMPTY_ARRAY then @value = [] ; control.next()

      when @B.EMPTY_STRING then @value = '' ; control.next()

      when @B.P1
        if @hasByte() then @value = @byte() + shift.b1 ; control.next()
        else @sign = 1 ; control.next N.int1

      when @B.N1
        if @hasByte() then @value = -1 * (@byte() + shift.b1) ; control.next()
        else @sign = -1 ; control.next N.int1

      when @B.P2
        if @hasBytes 2 then @value = @short() + shift.b2 ; control.next()
        else @sign = 1 ; control.next N.int2

      when @B.N2
        if @hasBytes 2 then @value = -1 * (@short() + shift.b2) ; control.next()
        else @sign = -1 ; control.next N.int2

      when @B.P3
        if @hasBytes 3 then @value = @int(3) + shift.b3 ; control.next()
        else @sign = 1 ; control.next N.int3

      when @B.N3
        if @hasBytes 3 then @value = -1 * (@int(3) + shift.b3) ; control.next()
        else @sign = -1 ; control.next N.int3

      when @B.P4
        if @hasBytes 4 then @value = @int(4) + shift.b4 ; control.next()
        else @sign = 1 ; control.next N.int4

      when @B.N4
        if @hasBytes 4 then @value = -1 * (@int(4) + shift.b4) ; control.next()
        else @sign = -1 ; control.next N.int4

      when @B.P5
        if @hasBytes 5 then @value = @int(5) + shift.b5 ; control.next()
        else @sign = 1 ; control.next N.int5

      when @B.N5
        if @hasBytes 5 then @value = -1 * (@int(5) + shift.b5) ; control.next()
        else @sign = -1 ; control.next N.int5

      when @B.P6
        if @hasBytes 6 then @value = @int(6) + shift.b6 ; control.next()
        else @sign = 1 ; control.next N.int6

      when @B.N6
        if @hasBytes 6 then @value = -1 * (@int(6) + shift.b6) ; control.next()
        else @sign = -1 ; control.next N.int6

      when @B.P7
        if @hasBytes 7 then @value = (@byte() * POW6) + @int(6) ; control.next()
        else @sign = 1 ; control.next N.int7

      when @B.N7
        if @hasBytes 7 then @value = (@byte() * NEG_POW6) - @int(6) ; control.next()
        else @sign = -1 ; control.next N.int7

      when @B.P8
        if @hasBytes 8 then @value = (@short() * POW6) + @int(6) ; control.next()
        else @sign = 1 ; control.next N.int8

      when @B.N8
        if @hasBytes 8 then @value = (@short() * NEG_POW6) - @int(6) ; control.next()
        else @sign = -1 ; control.next N.int8

      when @B.FLOAT4
        if @hasBytes 4 then @value = @float4() ; control.next()
        else control.next N.float4

      when @B.FLOAT8
        if @hasBytes 8 then @value = @float8() ; control.next()
        else control.next N.float8

      when @B.BYTES then control.next N.int, N.toBuffer

      else control.fail 'invalid specifier byte: ' + byte, byte: byte
