assert = require 'assert'

B = require '@endeo/bytes'

arrayT = require '../../lib/direct-nodes/arrayT.coffee'

testNode = require '../helpers/direct-node-test.coffee'

# callback order:  start value push
describe 'test arrayT', ->

  start = {}
  value = {}
  push  = {}
  callbackNodes = [ start, value, push ]

  it 'should wait for bytes', ->

    nextNodes = []
    testNode arrayT, callbackNodes, nextNodes, [], 'wait'


  it 'should pop array and consume sub-terminator', ->

    value = []
    nextNodes = []
    context = testNode arrayT, callbackNodes, nextNodes, [
      B.SUB_TERMINATOR
    ], 'next', array: value
    assert.equal context.array, null
    assert.equal context.value, value
    assert context.poppedArray


  it 'should pop array, consume terminator, and "start"', ->

    value = []
    nextNodes = [ start ]
    context = testNode arrayT, callbackNodes, nextNodes, [
      B.TERMINATOR
    ], 'next', array: value
    assert.equal context.array, null
    assert.equal context.value, value
    assert context.poppedArray


  it 'should queue array nodes', ->

    nextNodes = [ value, push ]
    context = testNode arrayT, callbackNodes, nextNodes, [ B.STRING ]
    assert.equal context.pushedArray, false
