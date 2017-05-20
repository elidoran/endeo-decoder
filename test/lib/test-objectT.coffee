assert = require 'assert'

B = require '@endeo/bytes'

objectT = require '../../lib/complex-nodes/objectT.coffee'

testNode = require '../helpers/complex-node-test.coffee'

describe 'test objectT', ->

  N = neededNodes =
    start : {}
    string: {}
    key   : {}
    value : {}
    assign: {}


  it 'should wait for bytes', ->

    nextNodes = []
    testNode objectT, neededNodes, nextNodes, [], 'wait'


  it 'should pop object and consume sub-terminator', ->

    value = {}
    nextNodes = []
    context = testNode objectT, neededNodes, nextNodes, [
      B.SUB_TERMINATOR
    ], 'next', object: value
    assert.equal context.object, null
    assert.equal context.value, value
    assert context.poppedObject


  it 'should pop object, consume terminator, and "start"', ->

    value = {}
    nextNodes = [ N.start ]
    context = testNode objectT, neededNodes, nextNodes, [
      B.TERMINATOR
    ], 'next', object: value
    assert.equal context.object, null
    assert.equal context.value, value
    assert context.poppedObject


  it 'should queue object nodes', ->

    nextNodes = [ N.string, N.key, N.value, N.assign ]
    context = testNode objectT, neededNodes, nextNodes, [ B.STRING ]
    assert.equal context.pushedArray, false
