# 'arrayT' node
module.exports = (control, N) ->

    if @hasByte()

      switch @peek()

        # this inner array is done so move to the next thing
        when @B.SUB_TERMINATOR
          @eat()
          @value = @array
          @popArray()
          control.next()

        # whole chunk is done now, go back to 'start'
        when @B.TERMINATOR
          @eat()
          @value = @array
          @popArray()
          control.next N.start

        # there's more value elements for the array
        else control.next N.value, N.push

    # wait for another byte
    else control.wait 'wait in arrayT'
