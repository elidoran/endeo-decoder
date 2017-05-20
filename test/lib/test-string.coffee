assert = require 'assert'

B = require '@endeo/bytes'

stringNode = require '../../lib/complex-nodes/string.coffee'

testNode = require '../helpers/complex-node-test.coffee'

describe 'test string', ->

  N = neededNodes =
    toString: {}
    restring: {}
    learn   : {}
    int     : {}
    stringId: {}
    int1: {}
    int2: {}
    int3: {}
    int4: {}
    int5: {}
    int6: {}
    int7: {}
    int8: {}


  it 'should wait without byte', ->
    testNode stringNode, neededNodes, [], [], 'wait'

  it 'should wait without second byte', ->
    testNode stringNode, neededNodes, [], [B.STRING], 'wait'

  it 'should fail with invalid specifier byte', ->
    testNode stringNode, neededNodes, [], [B.OBJECT], 'fail'


  it 'should use tiny int as length and go to toString w/out more bytes', ->
    length = 1
    context = testNode stringNode, neededNodes, [N.toString], [length], 'next'
    assert.equal context.integer, length


  it 'should use tiny int as length and get string from bytes', ->
    string = 'test'
    bytes = [ 4, 116, 101, 115, 116 ]
    context = testNode stringNode, neededNodes, [], bytes, 'next'
    assert.equal context.integer, null
    assert.equal context.$string, string

  it 'should go to int and restring for Sg', ->
    testNode stringNode, neededNodes, [ N.int, N.restring ], [B.GET_STRING]

  it 'should go to Sl nodes', ->
    nextNodes = [ N.int, N.stringId, N.int, N.toString, N.learn ]
    testNode stringNode, neededNodes, nextNodes, [B.NEW_STRING]

  for test in [
    { node: N.int1, byte: B.P1 }
    { node: N.int2, byte: B.P2 }
    { node: N.int3, byte: B.P3 }
    { node: N.int4, byte: B.P4 }
    { node: N.int5, byte: B.P5 }
    { node: N.int6, byte: B.P6 }
    { node: N.int7, byte: B.P7 }
    { node: N.int8, byte: B.P8 }
  ]
    do (test) ->

      it 'should next an int for length then toString', ->
        testNode stringNode, neededNodes, [test.node, N.toString], [test.byte]
