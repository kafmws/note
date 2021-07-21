<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=5 orderedList=false} -->

<!-- code_chunk_output -->

- [JavaScript: 基于原型的面向对象](#javascript-基于原型的面向对象)
  - [创建 JavaScript 对象](#创建-javascript-对象)
  - [基于原型的继承](#基于原型的继承)
      - [`prototype`属性与`__proto__`属性](#prototype属性与__proto__属性)
      - [`constructor`属性](#constructor属性)
      - [修改构造器的`prototype`属性](#修改构造器的prototype属性)

<!-- /code_chunk_output -->

## JavaScript: 基于原型的面向对象

### 创建 JavaScript 对象

- 直接定义一个对象

```JavaScript
// 定义对象的属性及方法
var person = {
  name: 'Bob',
  greeting: function () {
    alert('Hi! I\'m ' + this.name + '.');
  },
};

person.greeting();
```

- 使用类的构造函数

```JavaScript
// 构造函数通常使用大写字母开头
function Person(name, age, gender) {
  this.name = name;
  this.greeting = function () {
    alert('Hi! I\'m ' + this.name + '.');
  }
}

// 使用 new 关键字构造对象
var person = new Person('Bob');
var another = new Person('Jerry');
```

> 实际上在任何一个函数前使用`new`关键字，都可以将该函数作为构造函数制造对象
> 因此，`JavaScript`的设计并不严谨优雅

- 使用`Object()`构造函数
  使用`Object()`函数制造一个空对象，然后添加属性和方法
  还可以将对象定义作为`Object()`的参数

```JavaScript
var person1 = new Object();
  this.name= 'Bob';
  this.age= 22;
  this.gender='male';
  this.greeting= function () {
  alert('Hi! I'm ' + this.name + '.');
}

var person2 = new Object({
  name: 'Bob',
  age: 22,
  gender: 'male',
  greeting: function () {
    alert('Hi! I'm ' + this.name + '.');
  },
});
```

- 使用`Object.create()`方法

```JavaScript
var person2 = Object.create(person1);
```

person2 是基于 person1 创建的， person1 是 person2 的原型， person2 可以访问 person1 的属性和方法

---

### 基于原型的继承

不同于其他`OOP`，`JavaScript`的继承是一种基于原型的继承

我们可以不显式地定义类 ，而是在其它类的实例的基础上添加属性和方法来创建类，甚至偶尔使用空对象创建类

原型继承中，并没有把类的属性和方法都复制到实例中，而是在对象实例和其构造器直接建立一个链接（即对象的`__proto__`属性保存构造函数的`prototype`属性）
每个对象都是构造在原型对象之上，通过`__proto__`属性访问继承的属性和方法

简单来说就是，在不定义`Class`的情况下创建`Object`
继承表现为对象直接继承对象的形式（被继承的对象称为`原型对象`）

原型对象仍然可以具有原型，并从中继承方法和属性，一层一层、以此类推。这种关系常被称为原型链(`prototype chain`)

当访问某个对象的某个属性时，如果这个属性不存在于当前对象上，则访问其原型对象查找该属性，以此类推，直到不再具有原型对象。

##### `prototype`属性与`__proto__`属性

==构造函数具有`prototype`属性，所有会被继承的属性及方法都定义在这里==

> `prototype`属性即`原型`属性，在提到`原型`一词时需要注意区分指的是：
>
> 1. 构造函数的`原型`属性
> 2. 对象的`原型对象`
>    每个对象都有`__proto__`属性，`__proto__`属性存放原型对象

（在新的标准中，`__proto__`已由`Object.getPrototypeOf(obj)`替代）

由构造器制造的对象，其`__proto__`属性指向构造器的`prototype`对象
使用`Object.create()`方法由某对象制造的新对象，新对象的`__proto__`属性为原对象
默认情况下, 所有函数的原型属性的`__proto__`都是`window.Object.prototype`

```js
function Person() {}
var person1 = new Person();
var person2 = Object.create(person1);
person1.__proto__ === Person.prototype;
true;
person2.__proto__ === person;
true;
```

##### `constructor`属性

每个实例对象都从原型中继承了`constructor`属性，该属性指向了构造此实例对象的构造函数
每一个对象的`constructor`属性都应当返回构造此实例的构造函数

所以`new instance.constructor(arguments)`即是使用构造函数制造了一个对象
以及`instance.constructor.name`还能得到构造函数的名字

---

##### 修改构造器的`prototype`属性

- 在原型上增加方法

```JavaScript
Person.prototype.farewell = function () {
  alert(this.name.first + " has left the building. Bye for now!");
};
```

那么在这条原型链下游的原型/对象都可以上溯原型链，从而调用到这个方法
即使那些对象是在`Person`的`prototype`属性增加`farewell`方法之前创建的
这是原型机制实现的`OO`的特点之一

- 在原型上增加属性

```JavaScript
Person.prototype.fullName = "firstName lastName";
```

属于原型的属性，是该类的对象都可以访问到的唯一值，类似于类变量，常用来定义常属性（静态属性）

---

在构造函数中声明的属性是继承的属性

```JavaScript
function Person(first, last, age, gender, interests) {
  fullName = this.name.first + " " + this.name.last;
}
```

构造函数中的 this 是动态绑定的，因此访问到的是当前对象的 name

因此一种常见的对象（原型）定义模式是在构造器中定义属性，在 prototype 属性上定义方法

```JavaScript
// 构造器及其属性定义

function Test(a,b,c,d) {
  // 属性定义
  this.a = a;
  ...
};

// 定义第一个方法
Test.prototype.x = function () { ... }

// 定义第二个方法
Test.prototype.y = function () { ... }

// 等等......
```

---
