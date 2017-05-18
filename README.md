# @endeo/decoder
[![Build Status](https://travis-ci.org/elidoran/endeo-decoder.svg?branch=master)](https://travis-ci.org/elidoran/endeo-decoder)
[![Dependency Status](https://gemnasium.com/elidoran/endeo-decoder.png)](https://gemnasium.com/elidoran/endeo-decoder)
[![npm version](https://badge.fury.io/js/%40endeo%2Fdecoder.svg)](http://badge.fury.io/js/%40endeo%2Fdecoder)
[![Coverage Status](https://coveralls.io/repos/github/elidoran/endeo-decoder/badge.svg?branch=master)](https://coveralls.io/github/elidoran/endeo-decoder?branch=master)

A Transform for decoding endeo bytes.

Used by **endeo** as its `decoder()` implementation.

See packages:

1. [endeo](https://www.npmjs.com/package/endeo)
2. [enbyte](https://www.npmjs.com/package/enbyte)
3. [debyte](https://www.npmjs.com/package/debyte)


## Install

```sh
# endeo-std requires this and all other standard packages.

# used with endeo or with custom bytes/unstring/specials:
npm install --save @endeo/decoder

# used standalone with standard implementations:
npm install --save @endeo/decoder @endeo/bytes @endeo/specials unstring
```


## Usage

Primarily used as the standard `endeo.decoder()` implementation.

Usable directly and accepts options to configure its `bytes`, `unstring`, and `@endeo/specials`.

```javascript
// get builder:
var buildDecoder = require('@endeo/decoder')

// build default one which expects these packages are available:
//   @endeo/bytes
//   unstring
//   @endeo/specials
decoder = buildDecoder()

// pipe encoded byte into it:
sourceStream.pipe(decoder)

// Or, write bytes to it:
decoder.write(someBuffer)

// get result via 'data' event:
decoder.on('data', function(data) {
  // data is object/array/String
})

// Or, send object-mode output to another stream:
decoder.pipe(targetStream)


// customize options method #1, as direct objects:
decoder = buildDecoder({
  // for the 'context' used in the 'stating' nodes
  context: {
    bytes: /* custom bytes object */,
    unstring: /* custom unstring object */,
    specials: /* custom specials object */
  }
})

// customize options method #2, as properties:
decoder = buildDecoder({
  // for the 'context' used in the 'stating' nodes
  context: {
    // the context is built with prototype and properties
    // so you can customize the properties...
    props: {
      bytes: {
        value: /* custom bytes property */
      },
      unstring: {
         value: /* custom unstring property */
      }
      specials: {
        value: /* custom specials property */
      }
    }
  }
})

// the 'stating' package instance is set on the transform.
// in case you want to mess with it...
decoder.states
```


# [MIT License](LICENSE)
