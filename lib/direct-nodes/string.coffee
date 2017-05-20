# node 'string'
# this is a very complicated one.
# the top-level string can have a TERMINATOR after it to mean empty string.
# it also may have Sg Sn or an int after it for the three types:
#  get-string, new-string, int is length of string.
#
# 'start' worries about the TERMINATOR after it for empty string.
# coffeelint: disable=cyclomatic_complexity
module.exports = (control, N) ->

    # if we have a byte to figure out what to do
    if @hasByte()

      # get the byte and remember it cuz it's useful as an int.
      byte = @byte()

      if byte is @B.STRING
        if @hasByte() then byte = @byte()
        else return control.wait 'wait in string'

      # if it's a positive tiny int
      if byte < @B.MAX_POS
        # and we have that many bytes available
        if @hasBytes byte
          # create the string right now
          @$string = @string byte
          control.next()

        else # we don't have enough bytes, so, we'll have to wait for them.
          # remember how many we need
          @integer = byte
          # let toString take care of waiting and creating
          control.next N.toString

      else switch byte

        # TODO: could go faster if we try to get int right now...
        #       it's a lot to pull into this spot tho.
        when @B.GET_STRING then control.next N.int, N.restring

        # TODO: could go faster if we try to get stuff right now...
        #       it's a lot to pull into this spot tho.
        # TODO: could have 'int' stack a previous int value
        #       so we could remove stringId and have toString or learn pop
        when @B.NEW_STRING
          control.next N.int, N.stringId, N.int, N.toString, N.learn

        # TODO: faster to check for the bytes and get the number now...
        #       a lot to pull into here.
        #       could check for bytes amount and use functions directly...
        when @B.P1 then sign = 1 ; control.next N.int1, N.toString
        when @B.P2 then sign = 1 ; control.next N.int2, N.toString
        when @B.P3 then sign = 1 ; control.next N.int3, N.toString
        when @B.P4 then sign = 1 ; control.next N.int4, N.toString
        when @B.P5 then sign = 1 ; control.next N.int5, N.toString
        when @B.P6 then sign = 1 ; control.next N.int6, N.toString
        when @B.P7 then sign = 1 ; control.next N.int7, N.toString
        when @B.P8 then sign = 1 ; control.next N.int8, N.toString

        else control.fail 'invalid specifier byte for string', byte: byte

    else control.wait 'wait in string'
