assert = require 'assert'

B = require '@endeo/bytes'

node = require '../../lib/complex-nodes/special.coffee'

testNode = require '../helpers/complex-node-test.coffee'

describe 'test special', ->

  N = neededNodes =
    start: {}
    value: {}
    int  : {}
    special : {}
    defaults: {}
    specialT: {}


  it 'should wait for bytes', ->

    values = specIndex: 0, spec: array: ['non-zero-length']
    testNode node, neededNodes, [], [], 'wait', values


  it 'should assign the value and wait', ->

    key = 'key'
    val = 'test'
    values =
      value: val
      spec: array: [1, {key}, 3]
      specIndex: 1
      specObject: {}
    context = testNode node, neededNodes, [], [], 'wait', values
    assert.equal context.value, null
    assert.equal context.specObject[key], val
    assert.equal context.specIndex, 2


  it 'should pop spec and move to specialT', ->

    spec = array: []
    values =
      specIndex: 0
      spec: spec
      value: null
      popSpec: -> spec
    context = testNode node, neededNodes, [N.specialT], [], 'next', values
    assert.equal context.value, spec


  it 'should pop spec, consume sub terminator, and move to next', ->

    spec = array: []
    values =
      specIndex: 0
      spec: spec
      value: null
      popSpec: -> spec
    context = testNode node, neededNodes, [], [B.SUB_TERMINATOR], 'next', values
    assert.equal context.value, spec
    assert.equal context.index, 1


  it 'should pop spec, consume terminator, and move to start', ->

    spec = array: []
    values =
      specIndex: 0
      spec: spec
      value: null
      popSpec: -> spec
    context = testNode node, neededNodes, [N.start], [B.TERMINATOR], 'next', values
    assert.equal context.value, spec
    assert.equal context.index, 1


  it 'should pop spec, see non-terminator, and fail', ->

    spec = array: []
    values =
      specIndex: 0
      spec: spec
      value: null
      popSpec: -> spec
    context = testNode node, neededNodes, [], [B.STRING], 'fail', values
    assert.equal context.value, spec
    assert.equal context.index, 0 # back()'d


  it 'should see non-default and move to next nodes', ->

    spec = array: [1,2]
    values =
      specIndex: 0
      spec: spec
      value: null
      popSpec: -> spec
    nextNodes = [ N.value, N.special ]
    context = testNode node, neededNodes, nextNodes, [B.STRING], 'next', values
    assert.equal context.index, 0
    assert.equal context.specIndex, 0


  it 'should skip single default', ->

    spec = array: [1,2]
    values =
      specIndex: 0
      spec: spec
      value: null
      popSpec: -> spec
    nextNodes = []
    context = testNode node, neededNodes, nextNodes, [B.DEFAULT], 'wait', values
    assert.equal context.index, 1
    assert.equal context.specIndex, 1


  it 'should skip three defaults', ->

    spec = array: [1,2,3,4]
    values =
      specIndex: 0
      spec: spec
      value: null
      popSpec: -> spec
    nextNodes = []
    bytes = [B.DEFAULT,B.DEFAULT,B.DEFAULT]
    context = testNode node, neededNodes, nextNodes, bytes, 'wait', values
    assert.equal context.index, 3
    assert.equal context.specIndex, 3


  it 'should skip five defaults', ->

    spec = array: [1,2,3,4,5,6]
    values =
      specIndex: 0
      spec: spec
      value: null
      popSpec: -> spec
    nextNodes = []
    bytes = [B.DEFAULT5]
    context = testNode node, neededNodes, nextNodes, bytes, 'wait', values
    assert.equal context.index, 1
    assert.equal context.specIndex, 5


  it 'should skip n defaults and move to int', ->

    spec = array: [1,2]
    values =
      specIndex: 0
      spec: spec
      value: null
      popSpec: -> spec
    nextNodes = [ N.int, N.defaults, N.special ]
    bytes = [B.DEFAULTN]
    context = testNode node, neededNodes, nextNodes, bytes, 'next', values
    assert.equal context.index, 1


  it 'should skip 7+n defaults and move to int', ->

    spec = array: [1,2,3,4,5,6,7,8]
    values =
      specIndex: 0
      spec: spec
      value: null
      popSpec: -> spec
    nextNodes = [ N.int, N.defaults, N.special ]
    bytes = [B.DEFAULT, B.DEFAULT5, B.DEFAULT, B.DEFAULTN]
    context = testNode node, neededNodes, nextNodes, bytes, 'next', values
    assert.equal context.index, 4
    assert.equal context.specIndex, 7
