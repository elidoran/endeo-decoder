assert = require 'assert'

B = require '@endeo/bytes'

startNode = require '../../lib/complex-nodes/start.coffee'

testNode = require '../helpers/complex-node-test.coffee'

describe 'test start', ->

  N = neededNodes =
    start  : {}
    value  : {}
    generic: {}
    special: {}
    array  : {}
    push   : {}
    string : {}
    int    : {}
    stringT: {}
    key    : {}
    assign : {}


  for id in [ 0, 1, (B.SPECIAL - 1) ]

    do (id) ->

      it 'should handle special object id ' + id, ->

        nextNodes = [ N.specialStart ]
        context = testNode startNode, neededNodes, nextNodes, [ id ]
        assert.equal context.integer, id


  it 'should handle special marker', ->

    nextNodes = [ N.int, N.specialStart ]
    testNode startNode, neededNodes, nextNodes, [ B.SPECIAL ]


  it 'should handle object marker', ->

    nextNodes = [ N.generic ]
    testNode startNode, neededNodes, nextNodes, [ B.OBJECT ]


  it 'should handle array marker', ->

    nextNodes = [ N.array ]
    testNode startNode, neededNodes, nextNodes, [ B.ARRAY ]


  it 'should handle string marker', ->

    nextNodes = [ N.string, N.stringT ]
    testNode startNode, neededNodes, nextNodes, [ B.STRING ]


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
    context = testNode startNode, neededNodes, nextNodes, [
      B.OBJECT, B.SUB_TERMINATOR
    ]
    assert.deepEqual context.value, {}

  it 'should make empty object for OgT', ->

    nextNodes = [ N.start ]
    context = testNode startNode, neededNodes, nextNodes, [
      B.OBJECT, B.TERMINATOR
    ]
    assert.deepEqual context.value, {}

  it 'should push object and queue object nodes', ->

    nextNodes = [ N.string, N.key, N.value, N.assign ]
    context = testNode startNode, neededNodes, nextNodes, [
      B.OBJECT, B.STRING
    ]
    assert context.pushedObject


  it 'should make empty array for ATs', ->

    nextNodes = []
    context = testNode startNode, neededNodes, nextNodes, [
      B.ARRAY, B.SUB_TERMINATOR
    ]
    assert.deepEqual context.value, []

  it 'should make empty object for AT', ->

    nextNodes = [ N.start ]
    context = testNode startNode, neededNodes, nextNodes, [
      B.ARRAY, B.TERMINATOR
    ]
    assert.deepEqual context.value, []

  it 'should push array and queue array nodes', ->

    nextNodes = [ N.value, N.push ]
    context = testNode startNode, neededNodes, nextNodes, [
      B.ARRAY, B.STRING
    ]
    assert context.pushedArray
