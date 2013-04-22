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

class X_View
  Injector.register(@) #=> notify itself
  @inject:
    model: -> UserModel

Injector.mapSingleton UserModel, new UserModel #=> create UserModel instance

x = new X_View
console.log x.model #=> reference to UserModel instance via prototype
```

Injector.js tune to use on coffee.

### JavaScript

```javascript
function UserModel(){};

function X_View(){};
Injector.register(UserModel);
X_View.inject = {
  model:functon(){return UserModel;}
}

Injector.mapSingleton(UserModel, new UserModel);
var x = new X_View;
console.log(x.model);
```


## API

### Injector.mapValue

Allocate individual instance.

NOTICE: Injected value will be evaluated and initialized on first reference(getter).

`Injector.mapValue(Class[, args...])`

```coffee
# inject to class
class A
class B
  Injector.register(@)
  @inject:
    a: -> A
class C
  Injector.register(@)
  @inject:
    a: -> A

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
  Injector.register(@)
  @inject:
    a: -> A
class C
  @inject:
    a: -> A

Injector.mapSingleton A, new A
b = new B
c = new C
console.log b.a # exist a instance
console.log (b.a is c.a) # true
```

```coffee
# inject to class
class A
class B
  Injector.register(@)
  @inject:
    a: -> A

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
  Injector.register(@)
  @inject:
    a: -> A
Injector.mapSingleton A
b = new B
Injector.unmap A
console.log b.a # null
```

### Injector.ensureProperties

Ensure target being filled all injected properties

`Injector.ensureProperties(foo)`

```coffee
class A
class B
  Injector.register(@)
  @inject:
    a: -> A
  constructor:->
    Injector.ensureProperties(@)

# b = new B #=> error! A is not injected
Injector.mapSingleton A
b = new B # success
```

### new Injector'

Create child injector.
`new Injector`

```
childInjector = new Injector
childInjector.mapValue A
```


### ChangeLog

#### v0.0.2
- injector annotation must be defined as function or String
- fix mapValue update after unmap

#### v0.0.1
- release


### LICENSE

(The MIT License)

Copyright © 2013 Koutaro Chikuba

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
