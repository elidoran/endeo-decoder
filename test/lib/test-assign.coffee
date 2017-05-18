assert = require 'assert'

B = require '@endeo/bytes'

assignNode = require '../../lib/direct-nodes/assign.coffee'

testNode = require '../helpers/direct-node-test.coffee'

# callback order:  start string key value assign objectT
describe 'test assign', ->

  callbackNodes = [
    start     = {}
    string    = {}
    keyNode   = {}
    valueNode = {}
    assign    = {}
    objectT   = {}
  ]
  key   = 'key'
  value = 'value'

  it 'should fail without key', ->
    testNode assignNode, callbackNodes, [], [], 'fail'

  it 'should fail without value', ->
    testNode assignNode, callbackNodes, [], [], 'fail', {key}

  it 'should fail without object', ->
    testNode assignNode, callbackNodes, [], [], 'fail', {key, value}


  it 'should assign key/value on object', ->
    object = {}
    values = {key, value, object}
    context = testNode assignNode, callbackNodes, [objectT], [], 'next', values
    assert.equal context.key, null
    assert.equal context.value, null
    assert.equal context.object, object
    assert.deepEqual object, key:'value'


  it 'should assign key/value on object and sub terminate', ->
    object = {}
    values = {key, value, object}
    context = testNode assignNode, callbackNodes, [], [
      B.SUB_TERMINATOR
    ], 'next', values
    assert.equal context.key, null
    assert.equal context.value, object
    assert.equal context.object, null
    assert.deepEqual object, key:'value'

  it 'should assign key/value on object and terminate', ->
    object = {}
    values = {key, value, object}
    context = testNode assignNode, callbackNodes, [start], [
      B.TERMINATOR
    ], 'next', values
    assert.equal context.key, null
    assert.equal context.value, object
    assert.equal context.object, null
    assert.deepEqual object, key:'value'

  it 'should assign key/value on object and restart object nodes', ->
    object = {}
    values = {key, value, object}
    context = testNode assignNode, callbackNodes, [string,keyNode,valueNode,assign], [
      B.STRING
    ], 'next', values
    assert.equal context.key, null
    assert.equal context.value, null
    assert.equal context.object, object
    assert.deepEqual object, key:'value'
