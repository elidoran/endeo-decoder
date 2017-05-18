assert = require 'assert'

nodes = require '../../lib/nodes.coffee'

testIntNode = require '../helpers/int-node-test.coffee'


describe 'test nodes', ->

  it 'should take integer to update special index in specialDefaults()', ->

    integer = 7
    context = {integer, specIndex:0}
    called  = false
    control = next: -> called = true
    nodes.specialDefaults.call context, control
    assert.equal context.integer, null
    assert.equal context.specIndex, integer
    assert called


  it 'should error when specialDefaults() doesnt find integer', ->

    called  = false
    control = fail: -> called = true
    nodes.specialDefaults.call {}, control
    assert called


  it 'should take string as key in key()', ->

    $string  = 'test'
    context = {$string}
    called  = false
    control = next: -> called = true
    nodes.key.call context, control
    assert.equal context.$string, null
    assert.equal context.key, $string
    assert called


  it 'should error when key() doesnt find string', ->

    called  = false
    control = fail: -> called = true
    nodes.key.call {}, control
    assert called


  it 'should take integer as stringId in stringId()', ->

    integer = 123
    context = {integer}
    called  = false
    control = next: -> called = true
    nodes.stringId.call context, control
    assert.equal context.integer, null
    assert.equal context.stringId, integer
    assert called


  it 'should error when key() doesnt find string', ->

    called  = false
    control = fail: -> called = true
    nodes.stringId.call {}, control
    assert called


  it 'should use integer to get string from buffer in toString()', ->

    integer = 4
    string  = 'test'
    context =
      hasBytes: (n) -> n is integer
      integer : integer
      index   : 2
      string  : (n) -> if n is integer then string

    called  = false
    control = next: -> called = true

    nodes.toString.call context, control

    assert.equal context.integer, null
    assert.equal context.index, 2 + integer
    assert.equal context.$string, string
    assert called


  it 'should wait when toString() doesn\'t have enough bytes', ->

    integer = 1
    context =
      hasBytes: -> false
      integer : integer

    called  = false
    control = wait: -> called = true

    nodes.toString.call context, control

    assert.equal context.integer, integer
    assert.equal context.$string, null
    assert called


  it 'should error when toString() doesnt find integer', ->

    called  = false
    control = fail: -> called = true
    nodes.toString.call {}, control
    assert called


  it 'should use integer to restring in restring()', ->

    integer = 123
    string  = 'testing'
    context =
      integer: integer
      unstring: restring: (id) -> if id is integer then string

    called  = false
    control = next: -> called = true

    nodes.restring.call context, control

    assert.equal context.integer, null
    assert.equal context.$string, string
    assert called


  it 'should fail when unstring.restring() fails in restring()', ->

    integer = 123
    context =
      integer: integer
      unstring: restring: ->

    called  = false
    control = fail: -> called = true

    nodes.restring.call context, control

    assert.equal context.integer, null
    assert.equal context.$string, null
    assert called


  it 'should error when key() doesnt find string', ->

    called  = false
    control = fail: -> called = true
    nodes.restring.call {}, control
    assert called


  it 'should fail without stringId in learn()', ->

    stringId = 123
    string   = 'testing'
    learnedId = learnedString = null
    context =
      stringId: stringId
      $string : string
      unstring: learn: (id, s) -> learnedId = id ; learnedString = s

    called  = false
    control = next: -> called = true

    nodes.learn.call context, control

    assert.equal context.stringId, null
    assert.equal context.$string, null
    assert.equal learnedId, stringId
    assert.equal learnedString, string
    assert called


  it 'should fail without stringId in learn()', ->

    called  = false
    control = fail: -> called = true
    nodes.learn.call null, control
    assert called


  it 'should fail without $string in learn()', ->

    stringId = 123
    context =
      stringId: stringId

    called  = false
    control = fail: -> called = true

    nodes.learn.call context, control

    assert.equal context.stringId, stringId
    assert called


  it 'should use integer to get bytes from buffer in toBuffer()', ->

    integer = 4
    string  = 'test'
    context =
      hasBytes: (n) -> n is integer
      integer : integer
      index   : 5
      buffer  : Buffer.from 'plus ' + string + ' extra text'

    called  = false
    control = next: -> called = true

    nodes.toBuffer.call context, control

    assert.equal context.integer, null
    assert.equal context.index, 5 + integer
    assert.deepEqual context.value, Buffer.from string
    assert called


  it 'should wait when toBuffer() doesn\'t have enough bytes', ->

    integer = 1
    context =
      hasBytes: -> false
      integer : integer

    called  = false
    control = wait: -> called = true

    nodes.toBuffer.call context, control

    assert.equal context.integer, integer
    assert.equal context.value, null
    assert called


  it 'should error when toBuffer() doesnt find integer', ->

    called  = false
    control = fail: -> called = true
    nodes.toBuffer.call {}, control
    assert called

  controlNext = ->
    called: false
    next: -> @called = true

  controlWait = ->
    called: false
    wait: -> @called = true

  zeroes = [0, 0x20, 0, 0, 0, 0, 0, 0]

  for test in [ # also do negative version
    { node: nodes.int1, answer: 101, bytes: 1 }
    { node: nodes.int2, answer: 357, bytes: 2 }
    { node: nodes.int3, answer: 65893, bytes: 3 }
    { node: nodes.int4, answer: 16843109, bytes: 4 }
    { node: nodes.int5, answer: 4311810405, bytes: 5 }
    { node: nodes.int6, answer: 1103823438181, bytes: 6 }
    { node: nodes.int7, answer: 282578800148837, bytes: 7
      , array: [ 1, 1, 1, 1, 1, 1, 0x65] }
    { node: nodes.int8, answer: 9007199254740992, bytes: 8
      , array: [ 0, 0x20, 0, 0, 0, 0, 0, 0] }
  ]
    do (test) ->

      it 'should get integer in ' + test.node.name + '() (+' + test.answer + ')', ->

        control = controlNext()
        bytes   = (test.array ? zeroes).slice -test.bytes
        context = testIntNode test.node, 1, bytes, control
        assert.equal context.integer, test.answer
        assert control.called

      it 'should get integer in ' + test.node.name + '() (' + -test.answer + ')', ->

        control = controlNext()
        bytes   = (test.array ? zeroes).slice -test.bytes
        context = testIntNode test.node, -1, bytes, control
        assert.equal context.integer, -test.answer
        assert control.called

      for b in [0 ... test.bytes]
        do (b) ->
          it 'should wait in ' + test.node.name + ' (' + b + ' bytes)', ->

            control = controlWait()
            array   = test.array ? zeroes
            bytes   = array.slice -b or array.length # tail, or none
            testIntNode test.node, 1, bytes, control
            assert control.called



  it 'should get float in float4() (1.25)', ->
    called = false
    control = next: -> called = true
    context =
      hasBytes: (n) -> n is 4
      float4  : -> 1.25
    nodes.float4.call context, control
    assert.equal context.value, 1.25
    assert called

  it 'should wait in float4()', ->
    called = false
    control = wait: -> called = true
    context =
      hasBytes: (n) -> not n is 4
    nodes.float4.call context, control
    assert called


  it 'should get float in float8() (1.23)', ->
    called = false
    control = next: -> called = true
    context =
      hasBytes: (n) -> n is 8
      float8  : -> 1.23
    nodes.float8.call context, control
    assert.equal context.value, 1.23
    assert called

  it 'should wait in float8()', ->
    called = false
    control = wait: -> called = true
    context =
      hasBytes: (n) -> not n is 8
    nodes.float8.call context, control
    assert called
