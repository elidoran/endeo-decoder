# direct node 'stringT'
module.exports = (direct) ->

  start = null
  direct ['start'], (s) -> start = s

  (control) ->

    if @hasByte()

      @value = @$string
      @$string = null

      if @peek() is @B.TERMINATOR
        @eat()         # consume the TERMINATOR byte
        @value ?= ''   # empty string if we didn't decode one
        control.next start # after a TERMINATOR always go to 'start'

      else control.next()

    else control.wait 'wait in stringT'
