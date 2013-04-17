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

  describe "#mapSingleton", ->
    it "should inject before new", ->
      class X
      class Y
        Injector.register @
        @inject:
          x: X
      Injector.mapSingleton X
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
      Injector.mapSingleton X

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

