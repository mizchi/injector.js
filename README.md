# Injector.js

injector.js is JavaScript DI injector inspired by robotlegs(AS3)

## How to use

Include me.

```coffee
{Injector} = require "injector"
```

or

```
<script src="injector.js"></script>
```


```coffee

class UserModel
  constructor: ->
    @data = 3

class X_View
  Injector.register(@) #=> notify itself
  @inject:
    model: UserModel

Injector.mapValue UserModel #=> create UserModel instance

x = new X_View
console.log x.model #=> reference to UserModel instance via prototype
```
