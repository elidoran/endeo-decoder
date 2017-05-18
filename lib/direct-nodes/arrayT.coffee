# direct 'arrayT' node
module.exports = (direct) ->

  # make vars for the later function to close over
  start = value = push = null

  # register request to get their actual values later
  direct ['start', 'value', 'push'], (s, v, p) ->
    start = s
    value = v
    push  = p

  # build the real node function as a closure
  (control) ->

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
          control.next start

        # there's more value elements for the array
        else control.next value, push

    # wait for another byte
    else control.wait 'wait in arrayT'
