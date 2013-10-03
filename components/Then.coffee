noflo = require 'noflo'
Promise = require 'promise'
_ = require 'lodash'

class Then extends noflo.Component
  constructor: ->
    @inPorts =
      in: new noflo.Port 'object'
    @outPorts =
      out: new noflo.Port 'object'
      error: new noflo.Port 'object'
      success: new noflo.Port 'any'
      failure: new noflo.Port 'any'

    @inPorts.in.on 'connect', =>
      @groups = []
    @inPorts.in.on 'begingroup', (group) =>
      # Save the groups
      @groups.push group
      @outPorts.out.beginGroup group if @outPorts.out.isAttached()
    @inPorts.in.on 'endgroup', (group) =>
      @outPorts.out.endGroup() if @outPorts.out.isAttached()
    @inPorts.in.on 'disconnect', =>
      @outPorts.out.disconnect() if @outPorts.out.isAttached()

    @inPorts.in.on 'data', (promise) =>
      unless promise.then?
        @outPorts.error.send new Error 'Passed value must be a promise'
        @outPorts.error.disconnect()
        return

      groups = @groups

      # Prepare the success route, if applicable
      if @outPorts.success.isAttached()
        onFulfilled = (value) =>
          # Convert value into array
          if _.isArray value
            values = value
          else if value?
            values = [value]
          else
            values = []

          @outPorts.success.beginGroup group for group in groups
          @outPorts.success.send data for data in values
          # Send a null packet to make sure there's a connection in case there
          # is no value
          @outPorts.success.send null unless values.length > 0
          @outPorts.success.endGroup() for group in groups
          @outPorts.success.disconnect()

          # Pass through for promise
          value

      # Prepare the failure route, if applicable
      if @outPorts.failure.isAttached()
        onRejected = (reason) =>
          @outPorts.failure.beginGroup group for group in groups
          @outPorts.failure.send reason
          @outPorts.failure.endGroup() for group in groups
          @outPorts.failure.disconnect()

          # Pass through for promise
          reason

      # Apply 'then'
      promise.then onFulfilled, onRejected

      # Forward promise only if there's a receiver
      if @outPorts.out.isAttached()
        @outPorts.out.send promise

exports.getComponent = -> new Then
