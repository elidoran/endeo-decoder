# node 'specialStart'
# this node is responsible for:
#  1. ensuring we get `integer` for the special id
#  2. getting the "object spec" from the ID, or erroring
#  3. preparing the context for the repetitive calls to 'special'
#  4. moving to 'special' for the real processing
module.exports = (control, N) ->

    # need the `integer` as the "object spec" ID
    if @integer?

      # get the "object spec"
      spec = @specs[@integer]

      if spec? # setup processing this special

        # remember any current "spec" processing context
        @pushSpec spec

        # move to the node responsible for processing each step
        control.next N.special

      else control.fail 'invalid special id', id:@integer

      @integer = null

    else control.fail 'special requires integer'
