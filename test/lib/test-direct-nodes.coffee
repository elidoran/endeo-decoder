assert = require 'assert'
B = require '@endeo/bytes'
nodes = require '../../lib/direct-nodes/index.coffee'


describe 'test direct nodes are "direct"', ->

  for nodeName, node of nodes

    do (nodeName, node) ->

      describe nodeName, ->

        result = requests = callback = null

        it 'should be a function returning a function', ->

          result = node (requestedNodes, cb) ->
            requests = requestedNodes
            callback = cb

          assert.equal typeof(result), 'function'

        it 'should request nodes', -> assert requests?.length > 0
        it 'should provide a callback', -> assert callback?
