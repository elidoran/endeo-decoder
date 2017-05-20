# 'push' node
module.exports = (control, N) ->

    # assign value into object at key
    if @value?

      if @array?

        @array[@array.length] = @value
        @value = null

        # check for Ts/T, if there's a byte... otherwise...
        if @hasByte()

          switch @peek()

            # this inner object is done so move to the next thing
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

        # go there and wait for another byte
        else control.next N.arrayT

      else control.fail 'missing array to add value to'

    else control.fail 'missing value to add to array'
