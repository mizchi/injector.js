# Injector.js

injector.js is JavaScript DI injector inspired by robotlegs(AS3).

Inject value with class flagment annotation.

## How to use

Include me.

```coffee
{Injector} = require "injector"
```

or

```
<script src="injector.js"></script>
```

### CoffeeScript

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

Injector.js tune to use on coffee.

### JavaScript

```
Injector = require("./injector").Injector;

function UserModel(){};

function X_View(){};
Injector.register(Y);
X_View.inject = {
  model:UserModel
}

Injector.mapValue(UserModel);
var x = new X_View;
console.log(x.model);
```




## API

### Injector.mapValue

Allocate individual instance.

`Injector.mapValue(Class[, args...])`

```coffee
# inject to class
class A
class B
  @inject:
    a: A
class C
  @inject:
    a: A

# use
Injector.mapValue A
b = new B
c = new C
console.log b.a # exist a instance
console.log (b.a is c.a) # false
```

### Injector.mapSingleton

Allocate singleton instance.

`Injector.mapSingleton(Class[, instance])`

```coffee
# inject to class
class A
class B
  @inject:
    a: A
class C
  @inject:
    a: A

Injector.mapSingleton A
b = new B
c = new C
console.log b.a # exist a instance
console.log (b.a is c.a) # true
```

```coffee
# inject to class
class A
class B
  @inject:
    a: A

a = new A
Injector.mapSingleton A, a

b = new B
console.log (b.a is a) # true
```

### Injector.unmap

Delete injected values.

`Injector.mapSingleton()`

```coffee
class A
class B
  @inject:
    a: A
Injector.mapSingleton A
b = new B
Injector.unmap A
console.log b.a # null
```

### new Injector'

Create child injector.
`new Injector`

```
childInjector = new Injector
childInjector.mapValue A
```

