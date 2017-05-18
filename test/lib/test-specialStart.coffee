assert = require 'assert'

B = require '@endeo/bytes'

specialStart = require '../../lib/direct-nodes/specialStart.coffee'

testNode = require '../helpers/direct-node-test.coffee'

describe 'test specialStart', ->

  callbackNodes = [
    special = {}
  ]

  it 'should fail without integer', ->
    testNode specialStart, callbackNodes, [], [], 'fail'


  it 'should fail without spec', ->
    testNode specialStart, callbackNodes, [], [], 'fail',
      integer: 123
      specials: get: ->


  it 'should get/push spec and move to special', ->
    ID = 123
    object = some:'object'
    spec = some:'spec', creator: -> object
    pushedSpec = null
    values =
      integer: ID
      specials:
        get: (id) -> if id is ID then spec
      pushSpec: (s) -> pushedSpec = s

    testNode specialStart, callbackNodes, [special], [], 'next', values

    assert.equal pushedSpec, spec
