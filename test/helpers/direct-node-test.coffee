assert = require 'assert'
B = require '@endeo/bytes'
{Input} = require '@endeo/input'

module.exports = (direct, callbackNodes, nextNodes, bytes, controlType = 'next', values) ->

  # get the inner node and the direct callback
  callback = null
  node = direct ((_, cb) -> callback = cb)

  # provide the callback nodes to the callback so it's ready to run.
  callback.apply null, callbackNodes

  # setup context with input buffer with the desired byte
  context = Object.create Object.assign {
    buffer: Buffer.from bytes
    index: 0
    B: B
    $push: (v) -> @pushedValue = v
    pushObject: -> @pushedObject = true
    pushedObject: false
    pushArray: -> @pushedArray = true
    pushedArray: false
    popObject: -> @poppedObject = true ; @object = null
    poppedObject: false
    popArray: -> @poppedArray = true ; @array = null
    poppedArray: false
    pushSpec: -> @pushedSpec = true
    pushedSpec: false
    popSpec: -> @poppedSpec = true
    poppedSpec: false
  },  Input.prototype

  if values?
    context[key] = value for own key, value of values

  # setup a control to receive next()
  control =
    next : (n...) -> @nexts = n
    nexts: null
    wait : -> @waited = true
    waited: false
    fail : -> @failed = true
    failed: false

  # run it with context
  node.call context, control

  switch controlType
    when 'next'
      # ensure it called next() with the correct mock node
      assert control.nexts
      assert.deepEqual control.nexts, nextNodes

    when 'wait' then assert control.waited

    when 'fail' then assert control.failed

  return context
