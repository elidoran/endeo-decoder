assert = require 'assert'

B = require '@endeo/bytes'

generic = require '../../lib/direct-nodes/generic.coffee'

testNode = require '../helpers/direct-node-test.coffee'

# callback order:  start string key value assign
describe 'test generic', ->

  start  = {}
  string = {}
  key    = {}
  value  = {}
  assign = {}
  callbackNodes = [ start, string, key, value, assign ]

  it 'should wait for bytes', ->

    nextNodes = []
    testNode generic, callbackNodes, nextNodes, [], 'wait'


  it 'should make empty generic for Ts', ->

    nextNodes = []
    context = testNode generic, callbackNodes, nextNodes, [ B.SUB_TERMINATOR ]
    assert.deepEqual context.value, {}


  it 'should make empty generic for T', ->

    nextNodes = [ start ]
    context = testNode generic, callbackNodes, nextNodes, [ B.TERMINATOR ]
    assert.deepEqual context.value, {}


  it 'should push object and queue object nodes', ->

    nextNodes = [ string, key, value, assign ]
    context = testNode generic, callbackNodes, nextNodes, [ B.STRING ]
    assert context.pushedObject
