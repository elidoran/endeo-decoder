context = require './context'

states = require('stating')()

states.addAll require './nodes'
states.addAll require('./direct-nodes'), true
states.start 'start'

# export a function which creates a new decoder
module.exports = (options) ->
  transform = states.transform
    context: context options?.context
    transform:
      decodeStrings: true
      # NOTE: defaults to sending objects out.
      #       string results are an issue cuz they aren't objects.
      #       currently converting them to String instances.
      #       that doesn't seem desirable tho, so,
      #       if someone is using *only* top-level strings they should
      #       set this to false and we should send it as string
      readableObjectMode: options?.readableObjectMode ? true

  # provide the `stating` instance in case they want to mess with it
  transform.states = states
  return transform
