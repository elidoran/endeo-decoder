# 'assign' node
module.exports = (control, N) ->

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
                control.next N.start

              # there's more key/value pairs for the object
              else control.next N.string, N.key, N.value, N.assign

          # go there and wait for another byte
          else control.next N.objectT

        else control.fail 'missing object to assign key/value into'

      else control.fail 'missing value to assign into object'

    else control.fail 'missing key to assign value to in object'
