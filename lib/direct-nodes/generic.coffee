# direct node 'generic'
module.exports = (direct) ->

  # make vars for the later function to close over
  # NOTE: `assign` can do the "T or Ts or More" logic.
  start = string = key = value = assign = null

  # register request to get their actual values later
  direct ['start', 'string', 'key', 'value', 'assign'], (s, st, k, v, a) ->
    start  = s
    string = st
    key    = k
    value  = v
    assign = a

  # build the real node function as a closure
  (control) ->

    if @hasByte()

      switch @peek()

        # this inner object is done so move to the next thing
        when @B.SUB_TERMINATOR
          @eat()
          @value = {}
          control.next()

        # whole chunk is done now, go back to 'start'
        when @B.TERMINATOR
          @eat()
          @value = {}
          control.next start

        # there's more key/value pairs for the object
        else
          # create a new object scope (push current object and key onto a stack)
          @pushObject()
          control.next string, key, value, assign

    # wait for another byte
    else control.wait 'wait in generic'
