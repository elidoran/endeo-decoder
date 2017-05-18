assert = require 'assert'

B = require '@endeo/bytes'

pushNode = require '../../lib/direct-nodes/push.coffee'

testNode = require '../helpers/direct-node-test.coffee'

# callback order:  start value push arrayT
describe 'test push', ->

  callbackNodes = [
    start     = {}
    valueNode = {}
    push      = {}
    arrayT    = {}
  ]
  value = 'value'

  it 'should fail without value', ->
    testNode pushNode, callbackNodes, [], [], 'fail'

  it 'should fail without array', ->
    testNode pushNode, callbackNodes, [], [], 'fail', {value}


  it 'should push key/value on object', ->
    array = []
    values = {value, array}
    context = testNode pushNode, callbackNodes, [arrayT], [], 'next', values
    assert.equal context.value, null
    assert.equal context.array, array
    assert.deepEqual array, [value]


  it 'should push key/value on object and sub terminate', ->
    array = []
    values = {value, array}
    context = testNode pushNode, callbackNodes, [], [
      B.SUB_TERMINATOR
    ], 'next', values
    assert.equal context.value, array
    assert.equal context.array, null
    assert.deepEqual array, ['value']

  it 'should push value in array and terminate', ->
    array = []
    values = {value, array}
    context = testNode pushNode, callbackNodes, [start], [
      B.TERMINATOR
    ], 'next', values
    assert.equal context.value, array
    assert.equal context.array, null
    assert.deepEqual array, ['value']

  it 'should push value in array and restart array nodes', ->
    array = []
    values = {value, array}
    context = testNode pushNode, callbackNodes, [valueNode,push], [
      B.STRING
    ], 'next', values
    assert.equal context.value, null
    assert.equal context.array, array
    assert.deepEqual array, ['value']
