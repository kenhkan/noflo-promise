noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai' unless chai
  From = require '../components/From.coffee'
else
  From = require 'noflo-promise/components/From.js'

Promise = require 'promise'

describe 'From component', ->
  globals = {}

  beforeEach ->
    globals.c = From.getComponent()
    globals.in = noflo.internalSocket.createSocket()
    globals.out = noflo.internalSocket.createSocket()
    globals.c.inPorts.in.attach globals.in
    globals.c.outPorts.out.attach globals.out

  describe 'when intantiated', ->
    it 'should have an input port', ->
      chai.expect(globals.c.inPorts.in).to.be.an 'object'
    it 'should have an output port', ->
      chai.expect(globals.c.outPorts.out).to.be.an 'object'

  describe 'the conversion', ->
    it 'accepts a value as well as a promise', (done) ->
      globals.out.on 'data', (promise) ->
        chai.expect(promise).to.be.instanceof Promise
        done()

      globals.in.send 'not a promise'
      globals.in.disconnect()
