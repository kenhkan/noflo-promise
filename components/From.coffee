noflo = require 'noflo'
Promise = require 'promise'

class From extends noflo.Component
  constructor: ->
    @inPorts =
      in: new noflo.Port 'any'
    @outPorts =
      out: new noflo.Port 'object'

    @inPorts.in.on 'data', (value) =>
      @outPorts.out.send Promise.from value
      @outPorts.out.disconnect()

exports.getComponent = -> new From
