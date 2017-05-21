assert = require 'assert'

B = require '@endeo/bytes'

specialStart = require '../../lib/complex-nodes/specialStart.coffee'

testNode = require '../helpers/complex-node-test.coffee'

describe 'test specialStart', ->

  N = neededNodes =
    special: {}

  it 'should fail without integer', ->
    testNode specialStart, neededNodes, [], [], 'fail'


  it 'should fail without spec', ->
    testNode specialStart, neededNodes, [], [], 'fail',
      integer: 123
      specs: []


  it 'should get/push spec and move to special', ->
    ID = 123
    specs = []
    object = some:'object'
    spec = some:'spec', creator: -> object
    specs[ID] = spec
    pushedSpec = null
    values =
      integer: ID
      specs: specs
      pushSpec: (s) -> pushedSpec = s

    testNode specialStart, neededNodes, [N.special], [], 'next', values

    assert.equal pushedSpec, spec
