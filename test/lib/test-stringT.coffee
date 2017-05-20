assert = require 'assert'

B = require '@endeo/bytes'

stringT = require '../../lib/complex-nodes/stringT.coffee'

testNode = require '../helpers/complex-node-test.coffee'

describe 'test stringT', ->

  N = neededNodes =
    start: {}


  it 'should wait without byte', ->
    testNode stringT, neededNodes, [], [], 'wait'


  it 'should do next w/out terminator', ->
    testNode stringT, neededNodes, [], [B.STRING], 'next'


  it 'should go to start for terminator', ->
    testNode stringT, neededNodes, [N.start], [B.TERMINATOR], 'next'
