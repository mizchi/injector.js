# EXAMPLE
{Injector} = require "../src/injector"
class UserModel
  constructor: ->
    @x = 3

class Event
  constructor: ->
    this.date = new Date

class X_View
  Injector.register(@)
  @inject:
    model: UserModel
    event: Event

class Y_View
  Injector.register(@)
  @inject:
    model: UserModel
    event: Event

Injector.mapValue UserModel
Injector.mapSingleton Event

x = new X_View
Injector.ensureProperties x

y = new Y_View
console.log "x.model", x.model
x.model = 3
delete x.model
console.log "x.model", x.model
console.log "y.model", y.model
console.log x.event is y.event

Injector.unmap UserModel
console.log x.model
console.log x.event

Injector.unregister Y_View
console.log y.event

