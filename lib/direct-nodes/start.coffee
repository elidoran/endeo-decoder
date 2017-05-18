# direct node 'start'
module.exports = (direct) ->

  # make vars for the later function to close over
  start = value = generic = specialStart = array = push = string = null
  int = stringT = key = assign = null

  # register request to get their actual values later
  direct [
    'start', 'value', 'generic', 'specialStart', 'array', 'push', 'string'
    'int', 'stringT', 'key', 'assign'
  ], (s, v, og, sp, a, p, st, i, t, k, an) ->
    start   = s
    value   = v
    generic = og
    specialStart = sp
    array   = a
    push    = p
    string  = st
    int     = i
    stringT = t
    key     = k
    assign  = an

  # build the real node function as a closure
  (control) ->

    # if we're coming back here after decoding a value then use it
    if @value?
      val = @value
      @value = null
      # can't push a string for object mode, so:
      # TODO: somehow check if they set object mode to false
      #       and then always output a string instead...
      if typeof val is 'string' then val = new String val
      @$push val

    unless @hasByte() then return control.wait 'wait in start'

    # look at the first byte to decide which node we go to

    # check range before switch
    byte = @byte()

    if byte < @B.SPECIAL         # 0 < B.SPECIAL are ID's
      # TODO: could get the "spec" here and then go to 'special' ...
      @integer = byte            # remember the id
      control.next specialStart  # go direct to the special handler

    # now check exact matches
    else switch byte

      # then it's an extended ID, 'int' gets the ID, then on to `special`
      # TODO: could get the "spec" here and then go to 'special' ...
      when @B.SPECIAL then control.next int, specialStart

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
              control.next start
            else
              @pushObject()
              control.next string, key, value, assign
        else control.next generic

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
              control.next start
            else
              @pushArray()
              control.next value, push
        else control.next array


      # we know length of all string styles so no TERMINATOR is required
      # unless the string is empty, so, look for it.
      when @B.STRING then control.next string, stringT

      else control.fail 'invalid indicator byte', byte: byte
