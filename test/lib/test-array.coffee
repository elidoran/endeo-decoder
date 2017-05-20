assert = require 'assert'

B = require '@endeo/bytes'

array = require '../../lib/complex-nodes/array.coffee'

testNode = require '../helpers/complex-node-test.coffee'

describe 'test array', ->

  N = neededNodes =
    start: {}
    value: {}
    push : {}

  it 'should wait for bytes', ->

    nextNodes = []
    testNode array, neededNodes, nextNodes, [], 'wait'


  it 'should make empty array for Ts', ->

    nextNodes = []
    context = testNode array, neededNodes, nextNodes, [ B.SUB_TERMINATOR ]
    assert.deepEqual context.value, []


  it 'should make empty array for T', ->

    nextNodes = [ N.start ]
    context = testNode array, neededNodes, nextNodes, [ B.TERMINATOR ]
    assert.deepEqual context.value, []


  it 'should push array and queue array nodes', ->

    nextNodes = [ N.value, N.push ]
    context = testNode array, neededNodes, nextNodes, [ B.STRING ]
    assert context.pushedArray
