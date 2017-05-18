# direct node 'specialT'
module.exports = (direct) ->

  start = null
  direct ['start'], (s) -> start = s

  (control) ->

    if @hasByte()

      switch @byte()

        when @B.SUB_TERMINATOR then control.next()

        when @B.TERMINATOR then control.next start

        else
          @back()
          control.fail 'special requires terminator'

    else control.wait 'wait in specialT'
