assert = require 'assert'

B = require '@endeo/bytes'

generic = require '../../lib/complex-nodes/generic.coffee'

testNode = require '../helpers/complex-node-test.coffee'

describe 'test generic', ->

  N = neededNodes =
    start : {}
    string: {}
    key   : {}
    value : {}
    assign: {}

  it 'should wait for bytes', ->

    nextNodes = []
    testNode generic, neededNodes, nextNodes, [], 'wait'


  it 'should make empty generic for Ts', ->

    nextNodes = []
    context = testNode generic, neededNodes, nextNodes, [ B.SUB_TERMINATOR ]
    assert.deepEqual context.value, {}


  it 'should make empty generic for T', ->

    nextNodes = [ N.start ]
    context = testNode generic, neededNodes, nextNodes, [ B.TERMINATOR ]
    assert.deepEqual context.value, {}


  it 'should push object and queue object nodes', ->

    nextNodes = [ N.string, N.key, N.value, N.assign ]
    context = testNode generic, neededNodes, nextNodes, [ B.STRING ]
    assert context.pushedObject
