assert = require 'assert'

B = require '@endeo/bytes'

buildDecoder = require '../../lib/index.coffee'


buff = (array) ->

  # change byte arrays into Buffers so we can concat it all
  for el, i in array
    unless Buffer.isBuffer el then array[i] = Buffer.from el

  Buffer.concat array


describe 'test decoder', ->

  it 'should build', -> assert buildDecoder()

  it 'should decode a string', (done) ->

    decoder = buildDecoder()

    buffer = Buffer.concat [
      Buffer.from [ B.STRING, 7 ] # length=7 for 'testing'
      Buffer.from 'testing'
      Buffer.from [B.TERMINATOR]
    ]

    decoder.on 'error', done
    decoder.on 'data', (result) ->
      assert.equal result, 'testing'
      done()

    # all at once
    decoder.end buffer

  it 'should decode an array', (done) ->

    decoder = buildDecoder()

    string1 = 'testing'
    string2 = 'strings'

    answer = [ 1, string1, 2, string2, 3 ]

    buffer = buff [
      [
        B.ARRAY
        1
        B.STRING, string1.length ], Buffer.from string1
      [
        2
        B.STRING, string2.length ], Buffer.from string2
      [
        3
        B.TERMINATOR
      ]
    ]

    decoder.on 'error', done
    decoder.on 'data', (result) ->
      assert.deepEqual result, answer
      done()

    # all at once
    decoder.end buffer


  it 'should decode a generic object', (done) ->

    decoder = buildDecoder()

    answer =
      one: 1
      two: 2
      three: 3

    buffer = buff [
      [
        B.OBJECT
        B.STRING, 3 ], Buffer.from 'one'
      [
        1
        B.STRING, 3 ], Buffer.from 'two'
      [
        2
        B.STRING, 5 ], Buffer.from 'three'
      [
        3
        B.TERMINATOR
      ]
    ]

    decoder.on 'error', done
    decoder.on 'data', (result) ->
      assert.deepEqual result, answer
      done()

    # all at once
    decoder.end buffer


  it 'should decode a special object', (done) ->

    spec =
      creator: -> one: 0, two: 0, three: 0
      array: [
        { key: 'one', default: 0 }
        { key: 'two', default: 0 }
        { key: 'three', default: 0 }
      ]

    decoder = buildDecoder
      context:
        specs: [null, spec]

    answer =
      one: 1
      two: 2
      three: 3

    buffer = Buffer.from [
      1 # id
      1 # value 1
      2 # value 2
      3 # value 3
      B.TERMINATOR
    ]

    decoder.on 'error', done
    decoder.on 'data', (result) ->
      assert.deepEqual result, answer
      done()

    # all at once
    decoder.end buffer
