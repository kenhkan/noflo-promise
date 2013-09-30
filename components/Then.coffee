noflo = require 'noflo'
Promise = require 'promise'

class Then extends noflo.Component
  constructor: ->
    @inPorts =
      in: new noflo.Port 'object'
    @outPorts =
      out: new noflo.Port 'object'
      error: new noflo.Port 'object'
      success: new noflo.Port 'any'
      failure: new noflo.Port 'any'

    @inPorts.in.on 'data', (promise) =>
      unless promise instanceof Promise
        @outPorts.error.send new Error 'Passed value must be a promise'
        @outPorts.error.disconnect()
        return

      # Prepare the success route, if applicable
      if @outPorts.success.isAttached()
        onFulfilled = =>
          @outPorts.success.send data for data in arguments
          @outPorts.success.disconnect()

      # Prepare the failure route, if applicable
      if @outPorts.failure.isAttached()
        onRejected = =>
          @outPorts.failure.send data for data in arguments
          @outPorts.failure.disconnect()

      # Apply 'then'
      promise.then onFulfilled, onRejected

      # Forward promise only if there's a receiver
      if @outPorts.out.isAttached()
        @outPorts.out.send promise
        @outPorts.out.disconnect()

exports.getComponent = -> new Then
