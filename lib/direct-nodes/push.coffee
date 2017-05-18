# direct 'push' node
module.exports = (direct) ->

  # make vars for the later function to close over
  start = value = push = arrayT = null

  # register request to get their actual values later
  direct ['start', 'value', 'push', 'arrayT'], (s, v, p, a) ->
    start  = s
    value  = v
    push   = p
    arrayT = a

  # build the real node function as a closure
  (control) ->

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
              control.next start

            # there's more value elements for the array
            else control.next value, push

        # go there and wait for another byte
        else control.next arrayT

      else control.fail 'missing array to add value to'

    else control.fail 'missing value to add to array'
