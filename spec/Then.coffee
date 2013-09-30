noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai' unless chai
  Then = require '../components/Then.coffee'
else
  Then = require 'noflo-promise/components/Then.js'

Promise = require 'promise'

describe 'Then component', ->
  globals = {}

  beforeEach ->
    globals.c = Then.getComponent()
    globals.in = noflo.internalSocket.createSocket()
    globals.out = noflo.internalSocket.createSocket()
    globals.error = noflo.internalSocket.createSocket()
    globals.success = noflo.internalSocket.createSocket()
    globals.failure = noflo.internalSocket.createSocket()
    globals.c.inPorts.in.attach globals.in
    globals.c.outPorts.out.attach globals.out
    globals.c.outPorts.error.attach globals.error
    globals.c.outPorts.success.attach globals.success
    globals.c.outPorts.failure.attach globals.failure

  describe 'when intantiated', ->
    it 'should have an input port', ->
      chai.expect(globals.c.inPorts.in).to.be.an 'object'
    it 'should have an output port', ->
      chai.expect(globals.c.outPorts.out).to.be.an 'object'
      chai.expect(globals.c.outPorts.error).to.be.an 'object'
      chai.expect(globals.c.outPorts.success).to.be.an 'object'
      chai.expect(globals.c.outPorts.failure).to.be.an 'object'

  describe 'prerequisites', ->
    it 'accepts only a promise', (done) ->
      globals.error.on 'data', (e) ->
        chai.expect(e).to.be.instanceof Error
        chai.expect(e.message).to.exist
        done()

      globals.in.send 'not a promise'
      globals.in.disconnect()

  describe 'the fork', ->
    it 'forwards to SUCCESS upon, well, success!', (done) ->
      globals.success.on 'data', (data) ->
        chai.expect(data).to.equal 'success!'
        done()

      globals.in.send new Promise (resolve, reject) ->
        # Always resolve for success
        resolve 'success!'

      globals.in.disconnect()

    it 'forwards to FAILURE upon, well, failure!', (done) ->
      globals.success.on 'data', (data) ->
        chai.expect(data).to.equal 'failure!'
        done()

      globals.in.send new Promise (resolve, reject) ->
        # Always resolve for failure
        resolve 'failure!'
      globals.in.disconnect()
