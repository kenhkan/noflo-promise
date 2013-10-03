noflo = require 'noflo'
Promise = require 'promise'

class From extends noflo.Component
  constructor: ->
    @inPorts =
      in: new noflo.Port 'any'
    @outPorts =
      out: new noflo.Port 'object'

    @inPorts.in.on 'begingroup', (group) =>
      @outPorts.out.beginGroup group
    @inPorts.in.on 'endgroup', (group) =>
      @outPorts.out.endGroup()
    @inPorts.in.on 'disconnect', =>
      @outPorts.out.disconnect()

    @inPorts.in.on 'data', (value) =>
      @outPorts.out.send Promise.from value

exports.getComponent = -> new From
