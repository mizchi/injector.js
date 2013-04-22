{Injector} = require "../src/injector"
assert = require "assert"

# replace mocha later
describe = (str,fn) -> fn()
it = (str, fn) -> fn()

describe "Injector", ->
  describe "#mapValue", ->
    it "should inject before new", ->
      class X
      class Y
        Injector.register @
        @inject:
          x: X
      Injector.mapValue X
      y = new Y

      assert.ok y.x instanceof X

    it "should inject before new", ->
      class X
      class Y1
        Injector.register @
        @inject:
          x: X
      class Y2
        Injector.register @
        @inject:
          x: X
      Injector.mapValue X

      y1 = new Y1
      y2 = new Y2

      assert.ok y1.x isnt y2.x

    it "should change instance after unmap", ->
      class X
      class Y1
        Injector.register @
        @inject:
          x: X
      Injector.mapValue X
      y1 = new Y1
      assert.ok y1.x is y1.x

      # unmap
      last_x = y1.x
      Injector.unmap X
      assert.ok y1.x is null
      Injector.mapValue X
      assert.ok last_x isnt y1.x

  describe "#mapSingleton", ->
    it "should deliver existed instance", ->
      class X
      class Y
        Injector.register @
        @inject:
          x: X
      x = new X

      Injector.mapSingleton X, x
      y = new Y
      assert.ok y.x is x

    it "should inject before new", ->
      class X
      class Y1
        Injector.register @
        @inject:
          x: X
      class Y2
        Injector.register @
        @inject:
          x: X

      x = new X
      Injector.mapSingleton X, x

      y1 = new Y1
      y2 = new Y2

      assert.ok y1.x is y2.x

  describe "#unregister", ->
    it "should remove from inejected list", ->
      class X
      class Y
        Injector.register @
        @inject:
          x: X
      Injector.mapValue X
      y = new Y
      assert.ok y.x instanceof X

      Injector.unregister Y
      assert.ok y.x == null

  describe "#unmap", ->
    it "should remove injected object", ->
      class X
      class Y
        Injector.register @
        @inject:
          x: X
      Injector.mapValue X
      y = new Y
      assert.ok y.x instanceof X

      Injector.unmap X
      assert.ok y.x == null

  describe "#new", ->
    it "should instantiate new injector", ->
      childInjector = new Injector
      class X
      childInjector.mapValue X
