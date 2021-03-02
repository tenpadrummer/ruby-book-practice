## Rubyのモジュール

### モジュールとは
クラスのようで、クラスではない、プログラム上での役割や振る舞いをまとめるもの。

```
module モジュール名
end
```

#### classとの違い
* moduleからインスタンスが生成できない。
* moduleは他のmoduleやclass継承できない。

#### 用途
* 継承を使わずにクラスにインスタンスメソッドを追加および上書きする。（ミックスイン）
* 複数のクラスに対して共通の特異メソッド（クラスメソッド）を追加。（ミックスイン）
* 関数的メソッドの定義
* シングルトンオブジェクトのように使用し設定値を保持。

### モジュールのミックスイン(includeとextend)

#### モジュールをクラスにinclude

モジュール側でもprivatメソッドが使用可能（下の例では使用していない）

```
# ログ出力用のメソッドを提供するモジュール
module Loggable
  def log(text)
    puts "[LOG] #{text}"
  end
end

class Product
  # 上で作ったモジュールをinclude
  include Loggable

  def title
    log 'title is called.'
    'A great movie'
  end
end

class User
  # 上で作ったモジュールをinclude
  include Loggable

  def name
    log 'name is called.'
    'Alice'
  end
end

product = Product.new
product.title
#=> [LOG] title is called.
#   "A great movie"

user = User.new
user.name
#=> [LOG] name is called.
#   "Alice"
```

#### モジュールをextend

extendを使用すると、モジュール内のメソッドをそのクラスの特異メソッドにできる（クラスメソッド化）

```
module Loggable
  def log(text)
    puts "[LOG] #{text}"
  end
end

class Product
  # Loggableモジュールのメソッドを特異メソッド（クラスメソッド）としてミックスインする
  extend Loggable

  def self.create_products(names)
    # logメソッドをクラスメソッド内で呼び出す
    log 'create_products is called.'
    # 他の実装は省略
  end
end

Product.create_products([])
#=> [LOG] create_products is called.
Product.log('Hello.')
#=> [LOG] Hello.
```

### includeされたモジュールの有無確認

include?メソッドでクラスオブジェクトに引数で渡したモジュールがincludeされているかわかる。
ancestorsメソッドは、モジュールに加えスーパークラスの情報も配列になって返ってくる。
is_a?メソッドは直接インスタンスに対しモジュールがincludeしているかわかる。

### include先のメソッドを使用するモジュール
「メソッドを実行する瞬間にんそのメソッドが呼び出せればOK」という考え方は、モジュールも同じ。

```
module Taggable
  def price_tag
    "#{price}円"
  end
end

class Product
  include Taggable

  def price
    1000
  end
end

product = Product.new
product.price_tag
#=> "1000円"
```

### Enumerableモジュール
map, select, find, count → Enumerableモジュールで使用可能なメソッド。
【条件】include先のクラスでeachメソッドが実装されていること。

### Comparableモジュール
<, <=, ==, >, >=, between? → Comparableモジュールで使用可能なメソッド。
【条件】include先のクラスで<=>演算子を実装しておくこと。

※a<=>b
* aがbより大きいなら正の整数
* aとbが等しいなら0
* aがbより小さいなら負の整数
* aとbが比較できないならnil

### Kernelモジュール
puts, p, print, require, loop → Kernelモジュールで使用可能なメソッド。
ObjectクラスがKernelモジュールをincludeしているので、どこでもいつでも利用できる。

### mainという名前のObject
トップレベルに存在するmainという名のObjectクラスのインスタンス(self)

### クラスやモジュール自身もオブジェクト
Rubyは全てがオブジェクト。ClassクラスもModuleクラスもObjectクラスを継承している。

```
class User
end

# Userクラス自身のクラスはClassクラス
User.class #=> Class

# ClassクラスのスーパークラスはModuleクラス
Class.superclass #=> Module

module Loggable
end

# Loggableモジュール自身のクラスはModuleクラス
Loggable.class #=> Module

# ModuleクラスのスーパークラスはObjectクラス
Module.superclass #=> Object
```

### モジュールとインスタンス変数
モジュール内で定義したメソッド中でインスタンス変数を読み書きすると、include先のクラスのインスタンス変数を読み書きしたことと同じ。
(モジュールとミックスイン先のクラスでインスタンス変数を共有するのは好ましくない)

```
module NameChanger
  def change_name
    @name = 'ありす'
  end
end

class User
  include NameChanger

  attr_reader :name

  def initialize(name)
    @name = name
  end
end

user = User.new('alice')
user.name
#=> "alice"

user.change_name
user.name
#=> "ありす"
```

### モジュールを利用した名前空間の作成
「名前空間(ネームスペース)」

* クラス名の衝突を防止する
* クラスのグループ分け/カテゴリ分け

```
モジュール名::クラス名
```

モジュール構文やクラス構文をネストさせなくても"モジュール名::クラス名"のような形でクラスを定義できる。

### 関数や定数を提供するモジュールの作成
モジュールはモジュール単体でも使うことができる。

#### モジュールの特異メソッド
includeやextendを使用せず、モジュール自身に特異メソッドを定義することができる。

```
モジュール名.メソッド名
```

```
module Loggable
  # 特異メソッドとしてメソッドを定義
  def self.log(text)
    puts "[LOG] #{text}"
  end
end

Loggable.log('Hello.') #=> [LOG] Hello.

```

#### module_functionメソッド
モジュールはミックスインとしても使え、特異メソッドとしても使える。
両方で使えるメソッドを定義する場合、module_functionメソッドを使用し、対象のメソッドを指名する。
module_functionでモジュール関数となったメソッドは、他のクラスでミックスインすると自動的にprivateになる

```
module Loggable
  def log(text)
    puts "[LOG] #{text}"
  end
  # logメソッドをミックスインとしても、モジュールの特異メソッドとしても使えるようにする
  module_function :log
end

Loggable.log('Hello.')
#=> [LOG] Hello.

class Product
  include Loggable

  def title
    log 'title is called.'
    'A great movie'
  end
end

product = Product.new
product.title
#=> [LOG] title is called.
#   "A great movie"
```

#### モジュールの定数の定義
モジュールにも定数を定義可能。クラスと同じように可能。

#### モジュールの例

```
# モジュールの特異メソッドとしてのsqrt（平方根）メソッド
Math.sqrt(2) #=> 1.4142135623730951

class Calculator
  include Math

  def calc_sqrt(n)
    sqrt(n)
  end
end

calculator = Calculator.new
calculator.calc_sqrt(2)
#=> 1.4142135623730951
Math::E
#=> 2.718281828459045
Math::PI
#=> 3.141592653589793
```

### シングルトンパターンとは
「唯一、ひとつだけ」のオブジェクトを作る手法のこと。
オブジェクト指向プログラミングの設計手法。

### ::と.の違い
二重コロン(::) → 右辺にメソッド、定数、クラス、モジュールOK
ドット(.) → 右辺がメソッドはOK,しかし定数やクラス、モジュールはNG