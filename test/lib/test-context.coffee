assert = require 'assert'

build = require '../../lib/context.coffee'

describe 'test context', ->

  it 'should build', -> assert build()


  for name in [
    'byte', 'peek', 'bytes', 'back', 'short', 'int', 'float4', 'float8', 'string'
    'hasByte', 'hasBytes'
  ]
    do (name) ->

      it 'should have function ' + name, ->

        # provide proto options and test for it
        options = proto: test: -> 'test'
        context = build options
        assert.equal typeof(context[name]), 'function'
        assert.equal typeof(context.test), 'function'


  for name in [
    'B', 'buffer', 'index', 'integer', 'unstring', 'specs'
  ]
    do (name) ->

      it 'should have property ' + name, ->
        assert.equal build()[name] isnt undefined, true

  it 'should $add() new input', ->

    context = build()
    buffer = Buffer.from 'test'
    context.$add buffer
    assert.equal context.buffer, buffer
    assert.equal context.index, 0

  it 'should append input in $add()', ->

    context = build()
    context.buffer = Buffer.from 'some test'
    context.index = 5
    context.$add Buffer.from 'ing'
    assert.equal context.buffer.toString('utf8'), 'testing'
    assert.equal context.index, 0

  it 'should assign a new object in pushObject()', ->

    context = build()
    context.pushObject()
    assert.deepEqual context.object, {}


  it 'should store current object/key and assign a new object in pushObject()', ->

    context = build()
    context.object = firstObject = {}
    context.key    = firstKey = 'test'
    context.pushObject()
    assert.deepEqual context.object, {}
    assert.equal context.key, null
    assert.equal context.objects[0][0], firstObject
    assert.equal context.objects[0][1], firstKey


  it 'should assign a new array in pushArray()', ->

    context = build()
    context.pushArray()
    assert.deepEqual context.array, []


  it 'should store current array and assign a new array in pushArray()', ->

    context = build()
    context.array = first = []
    context.pushArray()
    assert.deepEqual context.array, []
    assert.equal context.arrays[0], first


  it 'should pop object/key', ->

    context = build()
    context.objects.length = 0 # ensure empty
    context.objects[0] = [
      firstObject = {}
      firstKey = 'test'
    ]
    context.popObject()
    assert.equal context.object, firstObject
    assert.equal context.key, firstKey


  it 'should pop array', ->

    context = build()
    context.arrays.length = 0 # ensure it's empty
    context.arrays[0] = first = []
    context.popArray()
    assert.equal context.array, first


  it 'should use specified bytes (as bytes)', ->

    context = build bytes: bytes = custom:true
    assert.equal context.B, bytes


  it 'should use specified bytes (as props.B)', ->

    context = build props: B: value: bytes = custom:true
    assert.equal context.B, bytes


  it 'should use specified unstring (as option)', ->

    context = build unstring: unstring = custom:true
    assert.equal context.unstring, unstring


  it 'should use specified unstring (in props)', ->

    context = build props: unstring: value: unstring = custom:true
    assert.equal context.unstring, unstring


  it 'should use specified specs (as option)', ->

    context = build specs: specs = []
    assert.equal context.specs, specs


  it 'should use specified specs (in props)', ->

    context = build props: specs: value: specs = []
    assert.equal context.specs, specs


  it 'should assign spec in pushSpec()', ->

    object = some:'object'
    context = build()
    context.pushSpec spec = some:'spec', creator: -> object
    assert.deepEqual context.spec, spec
    assert.equal context.specIndex, 0
    assert.equal context.specObject, object


  it 'should store current spec info and assign then new one in pushSpec()', ->

    object = some:'object'
    context = build()
    context.spec       = firstSpec = first:'spec'
    context.specIndex  = firstIndex = 3
    context.specObject = firstObject = first:'object'
    context.pushSpec secondSpec = second:'spec', creator: -> object
    assert.deepEqual context.spec, secondSpec
    assert.equal context.specIndex, 0
    assert.deepEqual context.specObject, object
    assert.equal context.specs[0][0], firstSpec
    assert.equal context.specs[0][1], firstIndex
    assert.equal context.specs[0][2], firstObject


  it 'should pop spec', ->

    context = build()
    context.specs.length = 0 # ensure it's empty
    context.specObject = completed = completed:'spec'
    context.specs[0] = first = [
      spec = some:'spec'
      specIndex = 2
      specObject = some:'object'
    ]
    result = context.popSpec()
    assert.deepEqual context.spec, spec
    assert.equal context.specIndex, specIndex
    assert.deepEqual context.specObject, specObject
    assert.deepEqual result, completed
