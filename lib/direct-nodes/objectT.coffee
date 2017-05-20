# 'objectT' node
module.exports = (control, N) ->

    if @hasByte()

      switch @peek()

        # this inner object is done so move to the next thing
        when @B.SUB_TERMINATOR
          @eat()
          @value = @object
          @popObject()
          control.next()

        # whole chunk is done now, go back to 'start'
        when @B.TERMINATOR
          @eat()
          @value = @object
          @popObject()
          control.next N.start

        # there's more key/value pairs for the object
        else control.next N.string, N.key, N.value, N.assign

    # wait for another byte
    else control.wait 'wait in objectT'
