# node 'array'
module.exports = (control, N) ->

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
        control.next N.start

      # there's more key/value pairs for the object
      else
        # create a new object scope (push current object and key onto a stack)
        @pushArray()
        control.next N.value, N.push

  # wait for another byte
  else control.wait 'wait in array'
