assert = require 'assert'

B = require '@endeo/bytes'

pushNode = require '../../lib/complex-nodes/push.coffee'

testNode = require '../helpers/complex-node-test.coffee'

describe 'test push', ->

  N = neededNodes =
    start : {}
    value : {}
    push  : {}
    arrayT: {}

  value = 'value'

  it 'should fail without value', ->
    testNode pushNode, neededNodes, [], [], 'fail'

  it 'should fail without array', ->
    testNode pushNode, neededNodes, [], [], 'fail', {value}


  it 'should push key/value on object', ->
    array = []
    values = {value, array}
    context = testNode pushNode, neededNodes, [N.arrayT], [], 'next', values
    assert.equal context.value, null
    assert.equal context.array, array
    assert.deepEqual array, [value]


  it 'should push key/value on object and sub terminate', ->
    array = []
    values = {value, array}
    context = testNode pushNode, neededNodes, [], [
      B.SUB_TERMINATOR
    ], 'next', values
    assert.equal context.value, array
    assert.equal context.array, null
    assert.deepEqual array, ['value']

  it 'should push value in array and terminate', ->
    array = []
    values = {value, array}
    context = testNode pushNode, neededNodes, [N.start], [
      B.TERMINATOR
    ], 'next', values
    assert.equal context.value, array
    assert.equal context.array, null
    assert.deepEqual array, ['value']

  it 'should push value in array and restart array nodes', ->
    array = []
    values = {value, array}
    context = testNode pushNode, neededNodes, [N.value, N.push], [
      B.STRING
    ], 'next', values
    assert.equal context.value, null
    assert.equal context.array, array
    assert.deepEqual array, ['value']
