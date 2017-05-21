{Input} = require '@endeo/input'

# combine Input's prototype and our local proto once, now.
proto = Object.assign {}, Input.prototype,

  $add: (input) ->
    @buffer =
      # if there's some bytes leftover in the current buffer
      if @buffer?.length > 0 and @index < @buffer.length

        Buffer.concat [
          @buffer.slice @index, @buffer.length
          input
        ], (input.length + @buffer.length) - @index

      else input

    @index = 0
    return

  pushObject: ->
    if @object?
      @objects[@objects.length] = [@object, @key]
    @object = {}
    @key = null
    return

  pushArray: ->
    if @array? then @arrays[@arrays.length] = @array
    @array = []
    return

  popObject: ->
    [@object, @key] = @objects.pop() ? []
    return

  popArray: ->
    @array = @arrays.pop()
    return

  pushSpec: (spec) ->
    if @spec? then @specs[@specs.length] = [@spec, @specIndex, @specObject]
    @spec = spec
    @specIndex = 0
    @specObject = spec.creator()
    return

  popSpec: ->
    result = @specObject
    [@spec, @specIndex, @specObject] = @specs.pop() ? []
    return result


prop = (v, w) -> value:v, writable:w, configurable:false, enumerable:true

props =
  # input
  buffer : prop null, true # current bytes we're decoding
  index  : prop null, true # where in the buffer we're at

  # decode values
  value  : prop null, true
  integer: prop null, true # Input has a function named 'int'
  $string: prop null, true # Input has a function named 'string'

  # objects
  objects : prop [], false  # push/pop scope
  key     : prop null, true # the next key to assign a value to

  # special objects
  specs     : prop [], false  # push/pop scope
  spec      : prop null, true # the "object spec"
  specIndex : prop null, true # which key we're decoding a value for
  specObject: prop null, true # the object we're building up (decoding)

  # others
  sign    : prop 1, true    # whether next int is positive/negative
  arrays  : prop [], false
  stringId: prop null, true

  # left out on purpose so they are provided in builder
  # B (bytes)
  # unstring
  # specials


module.exports = (options) ->

  # allow them to provide custom stuff to override ours

  customProto = # copy to new object, our proto, then their proto.
    if options?.proto? then Object.assign {}, proto, options.proto
    else proto

  # these may be customized, but, when they aren't, use the standard ones.
  # when they specify the prop in options.props then we don't.
  # if they specify it in options then we use it in the prop.
  # otherwise, we require and build a standard one
  custom = {}

  unless options?.props?.B?
    value = options?.bytes ? require('@endeo/bytes')
    custom.B = prop value, false

  unless options?.props?.unstring?
    value = options?.unstring ? require('unstring') options?.unstringOptions
    custom.unstring = prop value, false

  unless options?.props?.specs?
    value = options?.specs ? []
    custom.specs = prop value, false


  # new object, our props, ensure `B` for bytes is supplied, then their props
  customProps = Object.assign {}, props, custom, options?.props

  Object.create customProto, customProps
