root = window ? exports ? this
class root.Injector
  # rootInjector pass Injector#[method]
  rootInjector = new this
  @register    : -> rootInjector.register     arguments...
  @unregister  : -> rootInjector.unregister   arguments...
  @mapSingleton: -> rootInjector.mapSingleton arguments...
  @mapValue    : -> rootInjector.mapValue     arguments...
  @unmap       : -> rootInjector.unmap        arguments...

  @ensureProperties: (instance)->
    for key of instance.constructor.inject
      if instance.hasOwnProperty key then throw new Error "Injected property must not be object own property"
      unless instance[k] then throw new Error "lack of [#{key}] on initialize"
    true

  _getInjectClass: (name) ->
    if (typeof name) is "string"
      val = @root
      for n in name.split('.')
        val = val[n]
      return val
    else if name instanceof Function
      return name()
    else
      return name

  constructor: (@root = root)->
    @known_list = []

  register: (Listener, inject = null) ->
    @known_list.push Listener
    for key of Listener.inject
      Object.defineProperty Listener.prototype, key,
        value: null
        writable: false
        configurable: true

    if inject then Listener.inject = inject

  unregister: (Listener)->
    n = @known_list.indexOf(Listener)
    for key of Listener.inject
      Object.defineProperty Listener.prototype, key,
        get: ->
          @['_' + key] = null
          null
        configurable: true
    @known_list.splice n, 1

  mapValue: (InjectClass, args...) ->
    @known_list.forEach (Listener) =>
      for key, f of Listener.inject
        val = @_getInjectClass(f)
        if val isnt InjectClass then continue

        # update count key for redefine
        cnt_key = "update#"+key

        # reset counter
        if Listener[cnt_key]?
          Listener[cnt_key]++
        else
          Object.defineProperty Listener, cnt_key,
            value: 0
            enumerable: false
            writable: true

        instance_key = "_" + key
        Object.defineProperty Listener.prototype, key,
          enumerable: false
          configurable: true
          get: ->
            # remove instnace if value is redefined
            if Listener[cnt_key] > @[cnt_key] then delete @[instance_key]

            # when instance is not defined, create new
            unless @[instance_key]
              @[instance_key] = new InjectClass args...
              # reset counter
              Object.defineProperty @, cnt_key,
                value: Listener[cnt_key]
                enumerable: false
                configurable: true
            return @[instance_key]

  mapSingleton: (InjectClass, instance) ->
    unless instance instanceof InjectClass
      throw "#{instance} is not #{InjectorClass} instance"

    @known_list.forEach (Listener) =>
      for key, f of Listener.inject
        val = @_getInjectClass(f)
        if val isnt InjectClass then continue

        if Listener::[key] then throw "#{key} already exists"
        Listener::[key] = instance

  unmap: (InjectClass = null) ->
    @known_list.forEach (Listener) =>
      for key, f of Listener.inject when !(InjectClass?) or @_getInjectClass(f) is InjectClass
        val = @_getInjectClass(f)

        Object.defineProperty Listener.prototype, key,
          value: null
          writable: false
          configurable: true

if typeof define is 'function' and typeof define.amd is 'object' and define.amd
  define -> Injector
