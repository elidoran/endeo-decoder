assert = require 'assert'

B = require '@endeo/bytes'

specialT = require '../../lib/complex-nodes/specialT.coffee'

testNode = require '../helpers/complex-node-test.coffee'

describe 'test specialT', ->

  N = neededNodes =
    start: {}

  it 'should wait for bytes', ->

    nextNodes = []
    testNode specialT, neededNodes, nextNodes, [], 'wait'


  it 'should consume sub-terminator', ->

    context = testNode specialT, neededNodes, [], [B.SUB_TERMINATOR]
    assert.equal context.index, 1 # should consume the byte


  it 'should consume terminator and "start"', ->

    context = testNode specialT, neededNodes, [N.start], [B.TERMINATOR]
    assert.equal context.index, 1 # should consume the byte


  it 'should queue object nodes', ->

    context = testNode specialT, neededNodes, [], [B.STRING], 'fail'
    assert.equal context.index, 0 # should NOT consume the byte
