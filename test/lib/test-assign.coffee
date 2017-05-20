assert = require 'assert'

B = require '@endeo/bytes'

assignNode = require '../../lib/complex-nodes/assign.coffee'

testNode = require '../helpers/complex-node-test.coffee'

describe 'test assign', ->

  N = neededNodes =
    start  : {}
    string : {}
    key    : {}
    value  : {}
    assign : {}
    objectT: {}

  key   = 'key'
  value = 'value'

  it 'should fail without key', ->
    testNode assignNode, neededNodes, [], [], 'fail'

  it 'should fail without value', ->
    testNode assignNode, neededNodes, [], [], 'fail', {key}

  it 'should fail without object', ->
    testNode assignNode, neededNodes, [], [], 'fail', {key, value}


  it 'should assign key/value on object', ->
    object = {}
    values = {key, value, object}
    context = testNode assignNode, neededNodes, [N.objectT], [], 'next', values
    assert.equal context.key, null
    assert.equal context.value, null
    assert.equal context.object, object
    assert.deepEqual object, key:'value'


  it 'should assign key/value on object and sub terminate', ->
    object = {}
    values = {key, value, object}
    context = testNode assignNode, neededNodes, [], [
      B.SUB_TERMINATOR
    ], 'next', values
    assert.equal context.key, null
    assert.equal context.value, object
    assert.equal context.object, null
    assert.deepEqual object, key:'value'

  it 'should assign key/value on object and terminate', ->
    object = {}
    values = {key, value, object}
    context = testNode assignNode, neededNodes, [N.start], [
      B.TERMINATOR
    ], 'next', values
    assert.equal context.key, null
    assert.equal context.value, object
    assert.equal context.object, null
    assert.deepEqual object, key:'value'

  it 'should assign key/value on object and restart object nodes', ->
    object = {}
    values = {key, value, object}
    nextNodes = [ N.string, N.key, N.value, N.assign]
    context = testNode assignNode, neededNodes, nextNodes, [
      B.STRING
    ], 'next', values
    assert.equal context.key, null
    assert.equal context.value, null
    assert.equal context.object, object
    assert.deepEqual object, key:'value'
