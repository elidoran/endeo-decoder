# direct 'assign' node
module.exports = (direct) ->

  # make vars for the later function to close over
  start = string = key = value = assign = objectT = null

  # register request to get their actual values later
  direct [
    'start', 'string', 'key', 'value', 'assign', 'objectT'
  ], (s, st, k, v, a, o) ->
    start  = s
    string = st
    key    = k
    value  = v
    assign = a
    objectT = o

  # build the real node function as a closure
  (control) ->

    # assign value into object at key
    if @key?

      if @value?

        if @object?

          @object[@key] = @value
          @key   = null
          @value = null

          # check for Ts/T, if there's a byte... otherwise...
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
                # shouldn't need to pop...but, it nulls it out, too.
                @popObject()
                control.next start

              # there's more key/value pairs for the object
              else control.next string, key, value, assign

          # go there and wait for another byte
          else control.next objectT

        else control.fail 'missing object to assign key/value into'

      else control.fail 'missing value to assign into object'

    else control.fail 'missing key to assign value to in object'
