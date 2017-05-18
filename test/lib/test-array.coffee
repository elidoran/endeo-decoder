assert = require 'assert'

B = require '@endeo/bytes'

array = require '../../lib/direct-nodes/array.coffee'

testNode = require '../helpers/direct-node-test.coffee'

# callback order:  start value push
describe 'test array', ->

  start = {}
  value = {}
  push  = {}
  callbackNodes = [ start, value, push ]

  it 'should wait for bytes', ->

    nextNodes = []
    testNode array, callbackNodes, nextNodes, [], 'wait'


  it 'should make empty array for Ts', ->

    nextNodes = []
    context = testNode array, callbackNodes, nextNodes, [ B.SUB_TERMINATOR ]
    assert.deepEqual context.value, []


  it 'should make empty array for T', ->

    nextNodes = [ start ]
    context = testNode array, callbackNodes, nextNodes, [ B.TERMINATOR ]
    assert.deepEqual context.value, []


  it 'should push array and queue array nodes', ->

    nextNodes = [ value, push ]
    context = testNode array, callbackNodes, nextNodes, [ B.STRING ]
    assert context.pushedArray
