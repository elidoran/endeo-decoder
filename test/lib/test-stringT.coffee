assert = require 'assert'

B = require '@endeo/bytes'

stringT = require '../../lib/direct-nodes/stringT.coffee'

testNode = require '../helpers/direct-node-test.coffee'

# callback order:  start
describe 'test stringT', ->

  callbackNodes = [
    start = {}
  ]

  it 'should wait without byte', ->
    testNode stringT, callbackNodes, [], [], 'wait'


  it 'should do next w/out terminator', ->
    testNode stringT, callbackNodes, [], [B.STRING], 'next'


  it 'should go to start for terminator', ->
    testNode stringT, callbackNodes, [start], [B.TERMINATOR], 'next'
