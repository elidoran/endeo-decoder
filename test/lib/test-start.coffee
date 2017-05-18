assert = require 'assert'

B = require '@endeo/bytes'

startNode = require '../../lib/direct-nodes/start.coffee'

testNode = require '../helpers/direct-node-test.coffee'

# callback order:
#   start value generic special array push string int stringT key assign
#
describe 'test start', ->

  callbackNodes = [
    start   = {}
    value   = {}
    generic = {}
    special = {}
    array   = {}
    push    = {}
    string  = {}
    int     = {}
    stringT = {}
    key     = {}
    assign  = {}
  ]

  for id in [ 0, 1, (B.SPECIAL - 1) ]

    do (id) ->

      it 'should handle special object id ' + id, ->

        nextNodes = [ special ]
        context = testNode startNode, callbackNodes, nextNodes, [ id ]
        assert.equal context.integer, id


  it 'should handle special marker', ->

    nextNodes = [ int, special ]
    testNode startNode, callbackNodes, nextNodes, [ B.SPECIAL ]


  it 'should handle object marker', ->

    nextNodes = [ generic ]
    testNode startNode, callbackNodes, nextNodes, [ B.OBJECT ]


  it 'should handle array marker', ->

    nextNodes = [ array ]
    testNode startNode, callbackNodes, nextNodes, [ B.ARRAY ]


  it 'should handle string marker', ->

    nextNodes = [ string, stringT ]
    testNode startNode, callbackNodes, nextNodes, [ B.STRING ]


  it 'should wait', ->

    testNode startNode, [], null, [], 'wait'


  it 'should fail on invalid marker', ->

    testNode startNode, [], null, [255], 'fail'


  it 'should use stored value', ->

    stringValue = 'test'
    context = testNode startNode, [], null, [], 'wait', value: stringValue
    assert.equal context.value, null
    assert.equal context.pushedValue, stringValue


  it 'should make empty object for OgTs', ->

    nextNodes = []
    context = testNode startNode, callbackNodes, nextNodes, [
      B.OBJECT, B.SUB_TERMINATOR
    ]
    assert.deepEqual context.value, {}

  it 'should make empty object for OgT', ->

    nextNodes = [ start ]
    context = testNode startNode, callbackNodes, nextNodes, [
      B.OBJECT, B.TERMINATOR
    ]
    assert.deepEqual context.value, {}

  it 'should push object and queue object nodes', ->

    nextNodes = [ string, key, value, assign ]
    context = testNode startNode, callbackNodes, nextNodes, [
      B.OBJECT, B.STRING
    ]
    assert context.pushedObject


  it 'should make empty array for ATs', ->

    nextNodes = []
    context = testNode startNode, callbackNodes, nextNodes, [
      B.ARRAY, B.SUB_TERMINATOR
    ]
    assert.deepEqual context.value, []

  it 'should make empty object for AT', ->

    nextNodes = [ start ]
    context = testNode startNode, callbackNodes, nextNodes, [
      B.ARRAY, B.TERMINATOR
    ]
    assert.deepEqual context.value, []

  it 'should push array and queue array nodes', ->

    nextNodes = [ value, push ]
    context = testNode startNode, callbackNodes, nextNodes, [
      B.ARRAY, B.STRING
    ]
    assert context.pushedArray
