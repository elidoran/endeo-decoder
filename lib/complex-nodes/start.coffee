# node 'start'
module.exports = (control, N) ->

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

    if byte < @B.SPECIAL          # 0 < B.SPECIAL are ID's
      # TODO: could get the "spec" here and then go to 'special' ...
      @integer = byte             # remember the id
      control.next N.specialStart # go direct to the special handler

    # now check exact matches
    else switch byte

      # then it's an extended ID, 'int' gets the ID, then on to `special`
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


      # we know length of all string styles so no TERMINATOR is required
      # unless the string is empty, so, look for it.
      when @B.STRING then control.next N.string, N.stringT

      else control.fail 'invalid indicator byte', byte: byte
