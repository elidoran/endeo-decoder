# direct node 'array'
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

        # this inner object is done so move to the next thing
        when @B.SUB_TERMINATOR
          @eat()
          @value = []
          control.next()

        # whole chunk is done now, go back to 'start'
        when @B.TERMINATOR
          @eat()
          @value = []
          control.next start

        # there's more key/value pairs for the object
        else
          # create a new object scope (push current object and key onto a stack)
          @pushArray()
          control.next value, push

    # wait for another byte
    else control.wait 'wait in array'
