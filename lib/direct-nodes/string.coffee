# direct node 'string'
# this is a very complicated one.
# the top-level string can have a TERMINATOR after it to mean empty string.
# it also may have Sg Sn or an int after it for the three types:
#  get-string, new-string, int is length of string.
#
# 'start' worries about the TERMINATOR after it for empty string.
module.exports = (direct) ->

  # make vars for the later function to close over
  toString = restring = learn = int = stringId = null
  int1 = int2 = int3 = int4 = int5 = int6 = int7 = int8 = null

  # register request to get their actual values later
  # coffeelint: disable=spacing_after_comma
  direct [
    'toString', 'restring', 'learn', 'int', 'stringId'
    'int1', 'int2', 'int3', 'int4', 'int5', 'int6', 'int7', 'int8'
  ], (ts, rs, l, i, si, i1, i2, i3, i4, i5, i6, i7, i8) ->
    toString = ts
    restring = rs
    learn    = l
    int      = i
    stringId = si
    int1 = i1 ; int2 = i2 ; int3 = i3 ; int4 = i4
    int5 = i5 ; int6 = i6 ; int7 = i7 ; int8 = i8


  # build the real node function as a closure
  # coffeelint: disable=cyclomatic_complexity
  (control) ->

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
          control.next toString

      else switch byte

        # TODO: could go faster if we try to get int right now...
        #       it's a lot to pull into this spot tho.
        when @B.GET_STRING then control.next int, restring

        # TODO: could go faster if we try to get stuff right now...
        #       it's a lot to pull into this spot tho.
        # TODO: could have 'int' stack a previous int value
        #       so we could remove stringId and have toString or learn pop
        when @B.NEW_STRING then control.next int, stringId, int, toString, learn

        # TODO: faster to check for the bytes and get the number now...
        #       a lot to pull into here.
        #       could check for bytes amount and use functions directly...
        when @B.P1 then sign = 1 ; control.next int1, toString
        when @B.P2 then sign = 1 ; control.next int2, toString
        when @B.P3 then sign = 1 ; control.next int3, toString
        when @B.P4 then sign = 1 ; control.next int4, toString
        when @B.P5 then sign = 1 ; control.next int5, toString
        when @B.P6 then sign = 1 ; control.next int6, toString
        when @B.P7 then sign = 1 ; control.next int7, toString
        when @B.P8 then sign = 1 ; control.next int8, toString

        else control.fail 'invalid specifier byte for string', byte: byte

    else control.wait 'wait in string'
