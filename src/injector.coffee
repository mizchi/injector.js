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
    for key,f of instance.constructor.inject
      val = getInjectClass(f)
      if instance.hasOwnProperty key then throw new Error "Injected property must not be object own property"
      unless instance[k] then throw new Error "lack of [#{key}] on initialize"
    true

  getInjectClass = (name) ->
    if (typeof name) is "string"
      val = root
      for n in name.split('.')
        val = val[n]
      return val
    else if name instanceof Function
      return name()
    else
      return name

  constructor: ->
    @known_list = []

  register: (Listener)->
    @known_list.push Listener
    for key of Listener.inject
      Object.defineProperty Listener.prototype, key,
        value: null
        writable: false
        configurable: true

  unregister: (Listener)->
    n = @known_list.indexOf(Listener)
    for prop of Listener.inject
      Object.defineProperty Listener.prototype, prop,
        get: ->
          @['_' + prop] = null
          null
        configurable: true
    @known_list.splice n, 1

  mapValue: (Class, args...) ->
    @known_list.forEach (Listener) ->
      for key, f of Listener.inject when getInjectClass(f) is Class
        val = getInjectClass(f)

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
              @[instance_key] = new Class args...
              # reset counter
              Object.defineProperty @, cnt_key,
                value: Listener[cnt_key]
                enumerable: false
                configurable: true
            return @[instance_key]

  mapSingleton: (Class, instance) ->
    unless instance instanceof Class
      throw "#{instance} is not #{Class} instance"
    @known_list.forEach (Listener) ->
      for key, f of Listener.inject when getInjectClass(f) is Class
        val = getInjectClass(f)
        if Listener::[key] then throw "#{key} already exists"
        Listener::[key] = instance

  unmap: (Class = null) ->
    @known_list.forEach (Listener) ->
      for key, f of Listener.inject when !(Class?) or getInjectClass(f) is Class
        val = getInjectClass(f)
        Object.defineProperty Listener.prototype, key,
          value: null
          writable: false
          configurable: true

if typeof define is 'function' and typeof define.amd is 'object' and define.amd
  define -> Injector
