assert = require 'assert'

B = require '@endeo/bytes'

specialT = require '../../lib/direct-nodes/specialT.coffee'

testNode = require '../helpers/direct-node-test.coffee'

describe 'test specialT', ->

  callbackNodes = [ start = {} ]

  it 'should wait for bytes', ->

    nextNodes = []
    testNode specialT, callbackNodes, nextNodes, [], 'wait'


  it 'should consume sub-terminator', ->

    context = testNode specialT, callbackNodes, [], [B.SUB_TERMINATOR]
    assert.equal context.index, 1 # should consume the byte


  it 'should consume terminator and "start"', ->

    context = testNode specialT, callbackNodes, [start], [B.TERMINATOR]
    assert.equal context.index, 1 # should consume the byte


  it 'should queue object nodes', ->

    context = testNode specialT, callbackNodes, [], [B.STRING], 'fail'
    assert.equal context.index, 0 # should NOT consume the byte
