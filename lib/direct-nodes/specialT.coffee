# node 'specialT'
module.exports = (control, N) ->

    if @hasByte()

      switch @byte()

        when @B.SUB_TERMINATOR then control.next()

        when @B.TERMINATOR then control.next N.start

        else
          @back()
          control.fail 'special requires terminator'

    else control.wait 'wait in specialT'
