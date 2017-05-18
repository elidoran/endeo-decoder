assert = require 'assert'

B = require '@endeo/bytes'

valueNode = require '../../lib/direct-nodes/value.coffee'

testNode = require '../helpers/direct-node-test.coffee'

describe 'test value', ->

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
    int1    = {}
    int2    = {}
    int3    = {}
    int4    = {}
    int5    = {}
    int6    = {}
    int7    = {}
    int8    = {}
    float4  = {}
    float8  = {}
    toBuffer= {}
    specialStart = {}
  ]


  it 'should wait', ->

    testNode valueNode, callbackNodes, [], [], 'wait'


  it 'should fail on invalid marker', ->

    testNode valueNode, [], [], [255], 'fail'


  it 'binary should go to int and toBuffer', ->
      testNode valueNode, callbackNodes, [int,toBuffer], [B.BYTES]


  it 'string should go to string and stringT', ->
      testNode valueNode, callbackNodes, [string,stringT], [B.STRING]


  it 'true should set true value', ->
      context = testNode valueNode, callbackNodes, [], [B.TRUE]
      assert.equal context.value, true

  it 'false should set false value', ->
      context = testNode valueNode, callbackNodes, [], [B.FALSE]
      assert.equal context.value, false

  it 'null should set null value', ->
      context = testNode valueNode, callbackNodes, [], [B.NULL]
      assert.equal context.value, null

  it 'empty object should set {} value', ->
      context = testNode valueNode, callbackNodes, [], [B.EMPTY_OBJECT]
      assert.deepEqual context.value, {}

  it 'empty array should set [] value', ->
      context = testNode valueNode, callbackNodes, [], [B.EMPTY_ARRAY]
      assert.deepEqual context.value, []

  it 'empty string should set \'\' value', ->
      context = testNode valueNode, callbackNodes, [], [B.EMPTY_STRING]
      assert.equal context.value, ''

  it 'should handle special marker', ->

    nextNodes = [ int, specialStart ]
    testNode valueNode, callbackNodes, nextNodes, [ B.SPECIAL ]



  describe 'generic', ->

    it 'should wait at generic', ->

      testNode valueNode, callbackNodes, [generic], [ B.OBJECT ]


    it 'should make empty generic for Ts', ->

      nextNodes = []
      context = testNode valueNode, callbackNodes, nextNodes, [
        B.OBJECT, B.SUB_TERMINATOR
      ]
      assert.deepEqual context.value, {}


    it 'should make empty generic for T', ->

      nextNodes = [ start ]
      context = testNode valueNode, callbackNodes, nextNodes, [
        B.OBJECT, B.TERMINATOR
      ]
      assert.deepEqual context.value, {}


    it 'should push object and queue object nodes', ->

      nextNodes = [ string, key, value, assign ]
      context = testNode valueNode, callbackNodes, nextNodes, [
        B.OBJECT, B.STRING
      ]
      assert context.pushedObject


  describe 'array', ->

    it 'should wait at generic', ->

      testNode valueNode, callbackNodes, [array], [ B.ARRAY ]

    it 'should make empty array for Ts', ->

      nextNodes = []
      context = testNode valueNode, callbackNodes, nextNodes, [
        B.ARRAY, B.SUB_TERMINATOR
      ]
      assert.deepEqual context.value, []


    it 'should make empty array for T', ->

      nextNodes = [ start ]
      context = testNode valueNode, callbackNodes, nextNodes, [
        B.ARRAY, B.TERMINATOR
      ]
      assert.deepEqual context.value, []


    it 'should push array and queue array nodes', ->

      nextNodes = [ value, push ]
      context = testNode valueNode, callbackNodes, nextNodes, [
        B.ARRAY, B.STRING
      ]
      assert context.pushedArray



  describe 'ints', ->

    for test in [
      #  next, label,  bytes, (always hasByte() to decode tiny ints)
      [ [    ],      0, [0], true]
      [ [    ],      1, [1], true]
      [ [    ],    100, [100], true]
      [ [    ],     -1, [101]]
      [ [    ],   -100, [200]]

      [ [int1],    101, [B.P1, 0]]
      [ [int1],   -101, [B.N1, 0]]
      [ [int1],    356, [B.P1, 255]]
      [ [int1],   -356, [B.N1, 255]]

      [ [int2],    357, [B.P2, 0, 0]]
      [ [int2],   -357, [B.N2, 0, 0]]
      [ [int2],  65892, [B.P2, 255, 255]]
      [ [int2], -65892, [B.N2, 255, 255]]

      [ [int3],     65893, [B.P3, 0, 0, 0]]
      [ [int3],    -65893, [B.N3, 0, 0, 0]]
      [ [int3],  16843108, [B.P3, 255, 255, 255]]
      [ [int3], -16843108, [B.N3, 255, 255, 255]]

      [ [int4],    16843109, [B.P4, 0, 0, 0, 0]]
      [ [int4],   -16843109, [B.N4, 0, 0, 0, 0]]
      [ [int4],  4311810404, [B.P4, 255, 255, 255, 255]]
      [ [int4], -4311810404, [B.N4, 255, 255, 255, 255]]

      [ [int5],     4311810405, [B.P5, 0, 0, 0, 0, 0]]
      [ [int5],    -4311810405, [B.N5, 0, 0, 0, 0, 0]]
      [ [int5],  1103823438180, [B.P5, 255, 255, 255, 255, 255]]
      [ [int5], -1103823438180, [B.N5, 255, 255, 255, 255, 255]]

      [ [int6],    1103823438181, [B.P6, 0, 0, 0, 0, 0, 0]]
      [ [int6],   -1103823438181, [B.N6, 0, 0, 0, 0, 0, 0]]
      [ [int6],  282578800148836, [B.P6, 255, 255, 255, 255, 255, 255]]
      [ [int6], -282578800148836, [B.N6, 255, 255, 255, 255, 255, 255]]

      [ [int7],   282578800148837, [B.P7, 1, 1, 1, 1, 1, 1, 0x65]]
      [ [int7],  -282578800148837, [B.N7, 1, 1, 1, 1, 1, 1, 0x65]]
      [ [int7],  9007199254740992, [B.P7, 0x20, 0, 0, 0, 0, 0, 0]]
      [ [int7], -9007199254740992, [B.N7, 0x20, 0, 0, 0, 0, 0, 0]]

      [ [int8],  9007199254740992, [B.P8, 0, 0x20, 0, 0, 0, 0, 0, 0]]
      [ [int8], -9007199254740992, [B.N8, 0, 0x20, 0, 0, 0, 0, 0, 0]]
    ]

      do (test) ->

        [nextNode, label, bytes, hasByte] = test

        it 'immediately decode ' + label, ->

          # has the bytes so it decodes immediately and calls next() w/out nodes.
          context = testNode valueNode, callbackNodes, [], bytes
          assert.equal context.value, label

        it 'call next(int#) to wait at that node for ' + label, ->

          if hasByte isnt true # hasByte/hasBytes so will decode immiediately
            # only has specifier byte, no more, does next() for the node
            testNode valueNode, callbackNodes, nextNode, bytes.slice(0,1)



  describe 'floats', ->

    it 'should get float in float4() (1.25)', ->
      buffer = Buffer.alloc 4
      buffer.writeFloatBE 1.25, 0, true
      bytes = [ B.FLOAT4, buffer[0], buffer[1], buffer[2], buffer[3] ]
      context = testNode valueNode, callbackNodes, [], bytes
      assert.equal context.value, 1.25

    it 'should wait in float4()', ->
      testNode valueNode, callbackNodes, [float4], [B.FLOAT4]


    it 'should get float in float8() (1.23)', ->
      buffer = Buffer.alloc 8
      buffer.writeDoubleBE 1.23, 0, true
      bytes = [
        B.FLOAT8
        buffer[0], buffer[1], buffer[2], buffer[3]
        buffer[4], buffer[5], buffer[6], buffer[7]
      ]
      context = testNode valueNode, callbackNodes, [], bytes
      assert.equal context.value, 1.23

    it 'should wait in float8()', ->
      testNode valueNode, callbackNodes, [float8], [B.FLOAT8]


  # for id in [ 0, 1, (B.SPECIAL - 1) ]
  #
  #   do (id) ->
  #
  #     it 'should handle special object id ' + id, ->
  #
  #       nextNodes = [ special ]
  #       context = testNode valueNode, callbackNodes, nextNodes, [ id ]
  #       assert.equal context.integer, id
  #
  #
  # it 'should handle special marker', ->
  #
  #   nextNodes = [ int, special ]
  #   testNode valueNode, callbackNodes, nextNodes, [ B.SPECIAL ]
  #
  #
  # it 'should handle object marker', ->
  #
  #   nextNodes = [ generic ]
  #   testNode valueNode, callbackNodes, nextNodes, [ B.OBJECT ]
  #
  #
  # it 'should handle array marker', ->
  #
  #   nextNodes = [ array ]
  #   testNode valueNode, callbackNodes, nextNodes, [ B.ARRAY ]
  #
  #
  # it 'should handle string marker', ->
  #
  #   nextNodes = [ string, stringT ]
  #   testNode valueNode, callbackNodes, nextNodes, [ B.STRING ]
  #
  #
  # it 'should wait', ->
  #
  #   testNode valueNode, [], null, [], 'wait'
  #
  #
  # it 'should fail on invalid marker', ->
  #
  #   testNode valueNode, [], null, [255], 'fail'
  #
  #
  # it 'should use stored value', ->
  #
  #   stringValue = 'test'
  #   context = testNode valueNode, [], null, [], 'wait', value: stringValue
  #   assert.equal context.value, null
  #   assert.equal context.pushedValue, stringValue
  #
  #
  # it 'should make empty object for OgTs', ->
  #
  #   nextNodes = []
  #   context = testNode valueNode, callbackNodes, nextNodes, [
  #     B.OBJECT, B.SUB_TERMINATOR
  #   ]
  #   assert.deepEqual context.value, {}
  #
  # it 'should make empty object for OgT', ->
  #
  #   nextNodes = [ start ]
  #   context = testNode valueNode, callbackNodes, nextNodes, [
  #     B.OBJECT, B.TERMINATOR
  #   ]
  #   assert.deepEqual context.value, {}
  #
  # it 'should push object and queue object nodes', ->
  #
  #   nextNodes = [ string, key, value, assign ]
  #   context = testNode valueNode, callbackNodes, nextNodes, [
  #     B.OBJECT, B.STRING
  #   ]
  #   assert context.pushedObject
  #
  #
  # it 'should make empty array for ATs', ->
  #
  #   nextNodes = []
  #   context = testNode valueNode, callbackNodes, nextNodes, [
  #     B.ARRAY, B.SUB_TERMINATOR
  #   ]
  #   assert.deepEqual context.value, []
  #
  # it 'should make empty object for AT', ->
  #
  #   nextNodes = [ start ]
  #   context = testNode valueNode, callbackNodes, nextNodes, [
  #     B.ARRAY, B.TERMINATOR
  #   ]
  #   assert.deepEqual context.value, []
  #
  # it 'should push array and queue array nodes', ->
  #
  #   nextNodes = [ value, push ]
  #   context = testNode valueNode, callbackNodes, nextNodes, [
  #     B.ARRAY, B.STRING
  #   ]
  #   assert context.pushedArray
