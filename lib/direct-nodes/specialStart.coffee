# direct node 'specialStart'
# this node is responsible for:
#  1. ensuring we get `integer` for the special id
#  2. getting the "object spec" from the ID, or erroring
#  3. preparing the context for the repetitive calls to 'special'
#  4. moving to 'special' for the real processing
module.exports = (direct) ->

  # make vars for the later function to close over
  special = null

  # register request to get their actual values later
  direct ['special'], (s) -> special = s

  # build the real node function as a closure
  (control) ->

    # need the `integer` as the "object spec" ID
    if @integer?

      # get the "object spec"
      spec = @specials.get @integer

      if spec? # setup processing this special

        # remember any current "spec" processing context
        @pushSpec spec

        # move to the node responsible for processing each step
        control.next special

      else control.fail 'invalid special id', id:@integer

      @integer = null

    else control.fail 'special requires integer'
