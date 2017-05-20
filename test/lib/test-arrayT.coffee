assert = require 'assert'

B = require '@endeo/bytes'

arrayT = require '../../lib/complex-nodes/arrayT.coffee'

testNode = require '../helpers/complex-node-test.coffee'

describe 'test arrayT', ->

  N = neededNodes =
    start: {}
    value: {}
    push : {}

  it 'should wait for bytes', ->

    nextNodes = []
    testNode arrayT, neededNodes, nextNodes, [], 'wait'


  it 'should pop array and consume sub-terminator', ->

    value = []
    nextNodes = []
    context = testNode arrayT, neededNodes, nextNodes, [
      B.SUB_TERMINATOR
    ], 'next', array: value
    assert.equal context.array, null
    assert.equal context.value, value
    assert context.poppedArray


  it 'should pop array, consume terminator, and "start"', ->

    value = []
    nextNodes = [ N.start ]
    context = testNode arrayT, neededNodes, nextNodes, [
      B.TERMINATOR
    ], 'next', array: value
    assert.equal context.array, null
    assert.equal context.value, value
    assert context.poppedArray


  it 'should queue array nodes', ->

    nextNodes = [ N.value, N.push ]
    context = testNode arrayT, neededNodes, nextNodes, [ B.STRING ]
    assert.equal context.pushedArray, false
