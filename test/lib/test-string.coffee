assert = require 'assert'

B = require '@endeo/bytes'

stringNode = require '../../lib/direct-nodes/string.coffee'

testNode = require '../helpers/direct-node-test.coffee'

# callback order:  toString restring learn int stringId
describe 'test string', ->

  callbackNodes = [
    toString = {}
    restring = {}
    learn    = {}
    int      = {}
    stringId = {}
    int1 = {}
    int2 = {}
    int3 = {}
    int4 = {}
    int5 = {}
    int6 = {}
    int7 = {}
    int8 = {}
  ]

  it 'should wait without byte', ->
    testNode stringNode, callbackNodes, [], [], 'wait'

  it 'should wait without second byte', ->
    testNode stringNode, callbackNodes, [], [B.STRING], 'wait'

  it 'should fail with invalid specifier byte', ->
    testNode stringNode, callbackNodes, [], [B.OBJECT], 'fail'


  it 'should use tiny int as length and go to toString w/out more bytes', ->
    length = 1
    context = testNode stringNode, callbackNodes, [toString], [length], 'next'
    assert.equal context.integer, length


  it 'should use tiny int as length and get string from bytes', ->
    string = 'test'
    bytes = [ 4, 116, 101, 115, 116 ]
    context = testNode stringNode, callbackNodes, [], bytes, 'next'
    assert.equal context.integer, null
    assert.equal context.$string, string

  it 'should go to int and restring for Sg', ->
    testNode stringNode, callbackNodes, [int,restring], [B.GET_STRING]

  it 'should go to Sl nodes', ->
    testNode stringNode, callbackNodes, [int,stringId,int,toString,learn], [B.NEW_STRING]

  for test in [
    { node: int1, byte: B.P1 }
    { node: int2, byte: B.P2 }
    { node: int3, byte: B.P3 }
    { node: int4, byte: B.P4 }
    { node: int5, byte: B.P5 }
    { node: int6, byte: B.P6 }
    { node: int7, byte: B.P7 }
    { node: int8, byte: B.P8 }
  ]
    do (test) ->

      it 'should next an int for length then toString', ->
        testNode stringNode, callbackNodes, [test.node,toString], [test.byte]
