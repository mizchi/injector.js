root = window ? exports ? this
class root.Injector
  rootInjector = new this
  @register    : -> rootInjector.register     arguments...
  @unregister  : -> rootInjector.unregister   arguments...
  @mapSingleton: -> rootInjector.mapSingleton arguments...
  @mapValue    : -> rootInjector.mapValue     arguments...
  @unmap       : -> rootInjector.unmap        arguments...

  @ensureProperties: (instance)->
    for k,v of instance.constructor.inject
      if instance.hasOwnProperty k then throw new Error "Injected property must not be object own property"
      unless instance[k] then throw new Error "lack of [#{k}] on initialize"
    true

  constructor: ->
    @known_list = []

  register: (ListnerClass)->
    @known_list.push ListnerClass
    for key of ListnerClass.inject
      Object.defineProperty ListnerClass.prototype, key,
        value: null
        writable: false
        configurable: true

  unregister: (ListnerClass)->
    n = @known_list.indexOf(ListnerClass)
    for k, v of ListnerClass.inject
      Object.defineProperty ListnerClass.prototype, k,
        value: null
        writable: false
        configurable: true
    @known_list.splice n, 1

  mapValue: (Class, args...) ->
    @known_list.forEach (ListnerClass) ->
      for key, val of ListnerClass.inject when val is Class
        if ListnerClass.prototype[key] then throw new Error "Already #{key} exists."

        cnt_key = "update#"+key

        # cnt reset
        if ListnerClass[cnt_key]?
          ListnerClass[cnt_key]++
        else
          Object.defineProperty ListnerClass, cnt_key,
            value: 0
            enumerable: false
            writable: true

        instance_key = "_" + key
        Object.defineProperty ListnerClass.prototype, key,
          enumerable: false
          configurable: true
          get: ->
            if ListnerClass[cnt_key] > @[cnt_key] then delete @[instance_key]
            unless @[instance_key]
              Object.defineProperty @, cnt_key,
                value: 0
                enumerable: false
                configurable: true

              @[instance_key] = new Class args...
            @[instance_key]

  mapSingleton: (Class, instance) ->
    unless instance instanceof Class
      throw "#{instance} is not #{Class} instance"
    @known_list.forEach (ListnerClass) ->
      for key, val of ListnerClass.inject when val is Class
        ListnerClass::[key] = instance

  unmap: (Class = null) ->
    @known_list.forEach (ListnerClass) ->
      for key, val of ListnerClass.inject when !(Class?) or val is Class
        Object.defineProperty ListnerClass.prototype, key,
          value: null
          writable: false
          configurable: true

if typeof define is 'function' and typeof define.amd is 'object' and define.amd
  define -> Injector
