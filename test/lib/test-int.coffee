assert = require 'assert'

B = require '@endeo/bytes'

{int} = require '../../lib/complex-nodes/index.coffee'

testNode = require '../helpers/complex-node-test.coffee'

N = neededNodes =
  int1: int1:true
  int2: int2:true
  int3: int3:true
  int4: int4:true
  int5: int5:true
  int6: int6:true
  int7: int7:true
  int8: int8:true

describe 'test int', ->

  for test in [
    #  next, label,  bytes, (always hasByte() to decode tiny ints)
    [ [      ],      0, [0], true]
    [ [      ],      1, [1], true]
    [ [      ],    100, [100], true]
    [ [      ],     -1, [101]]
    [ [      ],   -100, [200]]

    [ [N.int1],    101, [B.P1, 0]]
    [ [N.int1],   -101, [B.N1, 0]]
    [ [N.int1],    356, [B.P1, 255]]
    [ [N.int1],   -356, [B.N1, 255]]

    [ [N.int2],    357, [B.P2, 0, 0]]
    [ [N.int2],   -357, [B.N2, 0, 0]]
    [ [N.int2],  65892, [B.P2, 255, 255]]
    [ [N.int2], -65892, [B.N2, 255, 255]]

    [ [N.int3],     65893, [B.P3, 0, 0, 0]]
    [ [N.int3],    -65893, [B.N3, 0, 0, 0]]
    [ [N.int3],  16843108, [B.P3, 255, 255, 255]]
    [ [N.int3], -16843108, [B.N3, 255, 255, 255]]

    [ [N.int4],    16843109, [B.P4, 0, 0, 0, 0]]
    [ [N.int4],   -16843109, [B.N4, 0, 0, 0, 0]]
    [ [N.int4],  4311810404, [B.P4, 255, 255, 255, 255]]
    [ [N.int4], -4311810404, [B.N4, 255, 255, 255, 255]]

    [ [N.int5],     4311810405, [B.P5, 0, 0, 0, 0, 0]]
    [ [N.int5],    -4311810405, [B.N5, 0, 0, 0, 0, 0]]
    [ [N.int5],  1103823438180, [B.P5, 255, 255, 255, 255, 255]]
    [ [N.int5], -1103823438180, [B.N5, 255, 255, 255, 255, 255]]

    [ [N.int6],    1103823438181, [B.P6, 0, 0, 0, 0, 0, 0]]
    [ [N.int6],   -1103823438181, [B.N6, 0, 0, 0, 0, 0, 0]]
    [ [N.int6],  282578800148836, [B.P6, 255, 255, 255, 255, 255, 255]]
    [ [N.int6], -282578800148836, [B.N6, 255, 255, 255, 255, 255, 255]]

    [ [N.int7],   282578800148837, [B.P7, 1, 1, 1, 1, 1, 1, 0x65]]
    [ [N.int7],  -282578800148837, [B.N7, 1, 1, 1, 1, 1, 1, 0x65]]
    [ [N.int7],  9007199254740992, [B.P7, 0x20, 0, 0, 0, 0, 0, 0]]
    [ [N.int7], -9007199254740992, [B.N7, 0x20, 0, 0, 0, 0, 0, 0]]

    [ [N.int8],  9007199254740992, [B.P8, 0, 0x20, 0, 0, 0, 0, 0, 0]]
    [ [N.int8], -9007199254740992, [B.N8, 0, 0x20, 0, 0, 0, 0, 0, 0]]
  ]

    do (test) ->

      [nextNode, label, bytes, hasByte] = test

      it 'immediately decode ' + label, ->

        # has the bytes so it decodes immediately and calls next() w/out nodes.
        context = testNode int, neededNodes, [], bytes
        assert.equal context.integer, label

      it 'call next(int#) to wait at that node for ' + label, ->

        if hasByte isnt true # else we already did test above
          # only has specifier byte, no more, does next() for the node
          testNode int, neededNodes, nextNode, [bytes[0]]


  it 'should handle invalid specifier', ->

    # setup context with input buffer with the desired byte
    context =
      buffer: Buffer.from [ 255 ]
      index: 0
      B: B
      byte: -> @buffer[@index++]
      hasByte: -> @index < @buffer.length

    # setup a control to receive next()
    error = details = null
    control = fail: (e, d) -> error = e ; details = d

    # run it with context
    int.call context, control, neededNodes

    assert.equal error, 'invalid specifier byte for int'
    assert.deepEqual details, byte: 255
