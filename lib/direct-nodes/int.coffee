shift = require '../ints-shift'

POW6 = Math.pow 2, 48
NEG_POW6 = -POW6

# node 'int'
# coffeelint: disable=cyclomatic_complexity
module.exports = (control, N) ->

    # get the specifier byte to see which kind of int we have
    byte = @byte()

    if byte <= @B.MAX_POS
      @integer = byte
      control.next()

    else if byte <= @B.MAX_NEG
      @integer = -1 * (byte - @B.MAX_POS)
      control.next()

    else switch byte

      when @B.P1
        if @hasByte() then @integer = @byte() + shift.b1 ; control.next()
        else @sign = 1 ; control.next N.int1

      when @B.N1
        if @hasByte() then @integer = -1 * (@byte() + shift.b1) ; control.next()
        else @sign = -1 ; control.next N.int1

      when @B.P2
        if @hasBytes 2 then @integer = @short() + shift.b2 ; control.next()
        else @sign = 1 ; control.next N.int2

      when @B.N2
        if @hasBytes 2 then @integer = -1 * (@short() + shift.b2) ; control.next()
        else @sign = -1 ; control.next N.int2

      when @B.P3
        if @hasBytes 3 then @integer = @int(3) + shift.b3 ; control.next()
        else @sign = 1 ; control.next N.int3

      when @B.N3
        if @hasBytes 3 then @integer = -1 * (@int(3) + shift.b3) ; control.next()
        else @sign = -1 ; control.next N.int3

      when @B.P4
        if @hasBytes 4 then @integer = @int(4) + shift.b4 ; control.next()
        else @sign = 1 ; control.next N.int4

      when @B.N4
        if @hasBytes 4 then @integer = -1 * (@int(4) + shift.b4) ; control.next()
        else @sign = -1 ; control.next N.int4

      when @B.P5
        if @hasBytes 5 then @integer = @int(5) + shift.b5 ; control.next()
        else @sign = 1 ; control.next N.int5

      when @B.N5
        if @hasBytes 5 then @integer = -1 * (@int(5) + shift.b5) ; control.next()
        else @sign = -1 ; control.next N.int5

      when @B.P6
        if @hasBytes 6 then @integer = @int(6) + shift.b6 ; control.next()
        else @sign = 1 ; control.next N.int6

      when @B.N6
        if @hasBytes 6 then @integer = -1 * (@int(6) + shift.b6) ; control.next()
        else @sign = -1 ; control.next N.int6

      when @B.P7
        if @hasBytes 7 then @integer = (@byte() * POW6) + @int(6) ; control.next()
        else @sign = 1 ; control.next N.int7

      when @B.N7
        if @hasBytes 7 then @integer = (@byte() * NEG_POW6) - @int(6) ; control.next()
        else @sign = -1 ; control.next N.int7

      when @B.P8
        if @hasBytes 8 then @integer = (@short() * POW6) + @int(6) ; control.next()
        else @sign = 1 ; control.next N.int8

      when @B.N8
        if @hasBytes 8 then @integer = (@short() * NEG_POW6) - @int(6) ; control.next()
        else @sign = -1 ; control.next N.int8

      else control.fail 'invalid specifier byte for int', byte: byte
