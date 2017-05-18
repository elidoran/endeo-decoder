# used to shift int values back to their original value
module.exports = Object.create null,
  b1: configurable: false, writable: false, enumerable: true, value: 101
  b2: configurable: false, writable: false, enumerable: true, value: 357
  b3: configurable: false, writable: false, enumerable: true, value: 65893
  b4: configurable: false, writable: false, enumerable: true, value: 16843109
  b5: configurable: false, writable: false, enumerable: true, value: 4311810405
  b6: configurable: false, writable: false, enumerable: true, value: 1103823438181
  # no shifting above 6 bytes because JS can't handle nums above 53 bits.
  # b7: configurable: false, writable: false, enumerable: true, value: 282578800148837
