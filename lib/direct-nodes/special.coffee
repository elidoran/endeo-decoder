# direct node 'special'
# this node is responsible for:
#  1. "loop" which reads values for object
#  2. assign values into object
#  3. try to consume terminator, else go to specialT
#  4. try to skip default values, else go to specialDefaults
module.exports = (direct) ->

  # make vars for the later function to close over
  start = value = int = special = defaults = specialT = null

  # register request to get their actual values later
  direct [
    'start', 'value', 'int', 'special', 'specialDefaults', 'specialT'
  ], (s, v, i, sp, sd, m) ->
    start = s
    value = v
    int = i
    special = sp
    defaults = sd
    specialT = m

  # build the real node function as a closure
  (control) ->

    keyInfo = @spec.array[@specIndex]

    if @value? # then we have a value to set into our object

      @specObject[keyInfo.key] = @value
      @value = null
      @specIndex++ # move to the next one

    if @specIndex >= @spec.array.length

      @value = @popSpec()

      # so the next byte can be consumed if it's a T or Ts
      if @hasByte() then switch @byte()

        when @B.SUB_TERMINATOR then control.next()

        when @B.TERMINATOR then control.next start

        else @back() ; control.fail 'special requires terminator'

      # wait for a byte to check for the TERMINATOR
      else control.next specialT

    # loop as long as we both have bytes to check and they're defaults.
    else

      while @hasByte()

        switch @peek()

          # move to the next spec index and consume the byte
          when @B.DEFAULT
            @eat()
            @specIndex++

          # move up 5 spec indexes and consume the byte
          when @B.DEFAULT5
            @eat()
            @specIndex += 5

          when @B.DEFAULTN
            @eat()
            return control.next int, defaults, special

          # otherwise, get value() and then come back here.
          else
            # if the "object spec" has a custom decoder node then use it instead
            # NOTE:
            #  the "decoderNode" thing in @endeo/specials is not the most
            #  ideal solution, but, for now, it works.
            return control.next keyInfo.decoderNode ? value, special

      # wait for a byte so we can handle defaults or move on to 'value'
      control.wait 'wait in special defaults'

    return
