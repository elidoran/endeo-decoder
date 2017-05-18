# direct 'objectT' node
module.exports = (direct) ->

  # make vars for the later function to close over
  start = string = key = value = assign = null

  # register request to get their actual values later
  direct ['start', 'string', 'key', 'value', 'assign'], (s1, s2, k, v, a) ->
    start  = s1
    string = s2
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
          @value = @object
          @popObject()
          control.next()

        # whole chunk is done now, go back to 'start'
        when @B.TERMINATOR
          @eat()
          @value = @object
          @popObject()
          control.next start

        # there's more key/value pairs for the object
        else control.next string, key, value, assign

    # wait for another byte
    else control.wait 'wait in objectT'
