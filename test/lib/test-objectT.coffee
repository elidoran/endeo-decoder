assert = require 'assert'

B = require '@endeo/bytes'

objectT = require '../../lib/direct-nodes/objectT.coffee'

testNode = require '../helpers/direct-node-test.coffee'

describe 'test objectT', ->

  callbackNodes = [
    start  = {}
    string = {}
    key    = {}
    value  = {}
    assign = {}
  ]

  it 'should wait for bytes', ->

    nextNodes = []
    testNode objectT, callbackNodes, nextNodes, [], 'wait'


  it 'should pop object and consume sub-terminator', ->

    value = {}
    nextNodes = []
    context = testNode objectT, callbackNodes, nextNodes, [
      B.SUB_TERMINATOR
    ], 'next', object: value
    assert.equal context.object, null
    assert.equal context.value, value
    assert context.poppedObject


  it 'should pop object, consume terminator, and "start"', ->

    value = {}
    nextNodes = [ start ]
    context = testNode objectT, callbackNodes, nextNodes, [
      B.TERMINATOR
    ], 'next', object: value
    assert.equal context.object, null
    assert.equal context.value, value
    assert context.poppedObject


  it 'should queue object nodes', ->

    nextNodes = [ string, key, value, assign ]
    context = testNode objectT, callbackNodes, nextNodes, [ B.STRING ]
    assert.equal context.pushedArray, false
