## Rubyのクラス

### 「クラスを使うプログラミング」と「クラスのないプログラミング」

クラスは内部にデータを保存し、さらに保持しているデータを利用する独自のメソッドを展開できる。
データとデータに関わるメソッドが常にセットになるので、クラスを使わない場合と比較し、処理やデータの管理がしやすい。

使わない場合

```
users = []
users << { first_name: 'Alice', last_name: 'Ruby', age: 20 }
users << { first_name: 'Bob', last_name: 'Python', age: 30 }
users.each do |user|
  puts "氏名: #{user[:first_name]} #{user[:last_name]}、年齢: #{user[:age]}"
end

users = []
users << { first_name: 'Alice', last_name: 'Ruby', age: 20 }
users << { first_name: 'Bob', last_name: 'Python', age: 30 }
def full_name(user)
  "#{user[:first_name]} #{user[:last_name]}"
end
users.each do |user|
  puts "氏名: #{full_name(user)}、年齢: #{user[:age]}"
end
```

使う場合

```
class User
  attr_reader :first_name, :last_name, :age

  def initialize(first_name, last_name, age)
    @first_name = first_name
    @last_name = last_name
    @age = age
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end

users = []
users << User.new('Alice', 'Ruby', 20)
users << User.new('Bob', 'Python', 30)

users.each do |user|
  puts "氏名: #{user.full_name}、年齢: #{user.age}"
end

```

### オブジェクト指向プログラミングの用語

#### クラス
「オブジェクトの設計図」および「オブジェクトの雛形」と呼ばれる一種のデータ型。
クラスが同じであれば、保持している属性やメソッドは原則同じになる。

#### オブジェクト
クラスから作成されるデータのかたまり。
同じクラスから作成されたオブジェクトでは、同じ属性やメソッドを持つが属性に入ってるデータはオブジェクトごとに異なる。

#### インスタンス
オブジェクトと同じ。

#### レシーバ
「メソッドを呼び出された側」のことをさす。メソッドとの関係を説明する場合にもオブジェクトをレシーバと表現することもある。

#### メソッド
他の言語でいう「関数」のこと。オブジェクトがもつ「動作」「振る舞い」のこと。
つまり、何らかの処理をひとまとめにし名前をつけ、なんども再利用できるようにしたもの。

#### メッセージ
レシーバに対して、メソッドを呼びだすこと。
レシーバとメッセージはsmalltalkというオブジェクト指向言語でよく使われる。

#### 状態(ステート)
オブジェクトごとに保持されるデータのこと。
例えば、Userクラスにおける「名前」や「年齢」も「Userの状態」と表現できる。

#### 属性(アトリビュート、プロパティ)
オブジェクトから取得できる値のこと。多くの場合、アトリビュートは名詞。

### Rubyにおけるクラスの定義

```
class クラス名 ※クラス名はキャメルケースが基本。
end
```
### オブジェクトの生成とinitializeメソッド

newメソッドでオブジェクトは生成できる。
この時、インスタンスの初期化のために同時にinitializeメソッドが呼ばれる。
このメソッドはデフォルトでprivateになっている。

### インスタンスメソッド
クラス内でメソッドを定義すると、そのメソッドはインスタンスメソッドとなる。
クラスに対して呼び出すことができる。

### インスタンス変数とアクセサメソッド
同じインスタンス内部で共有される変数。@が先頭につく。

メソッドやブロックに内部で作成される変数をローカル変数という。
ローカル変数はブロックの内部のみで有効。またメソッドやブロックが呼び出されるたびに毎回作り直される。
アルファベットの小文字、またはアンダースコアから始まる。

インスタンス変数はクラスの外部から参照できない。そのため、参照したい場合は参照用メソッドが必要となる。
また外部で変更を行う場合も変更用のメソッドを定義することになる。

```
class User
  def initialize(name)
    @name = name
  end

  # @nameを外部から参照するためのメソッド(ゲッター)
  def name
    @name
  end

  # @nameを外部から変更するためのメソッド(セッター)
  def name=(value)
    @name = value
  end
end

user = User.new('Alice')
user.name = 'Bob' # 一見変数への代入に見えるが、実際はname=メソッドを呼びだしている。
user.name
```

インスタンス変数の値を読み書きするメソッドを「アクセサメソッド」と呼ぶ。
attr_accessorメソッドを使用。

attr_readerメソッドはインスタンス変数を読み取り専用にする。
attr_writerメソッドはインスタンス変数を書き込み専用にする。

```
class User

  attr_accessor :name #@nameを読み書きするならこちらを定義
  attr_reader :name #@nameを読みとるだけならこちらを定義
  attr_writer :name #@nameを書き込むだけならこちらを定義

  def initialize(name)
    @name = name
  end
end

user = User.new('Alice')
user.name = 'Bob' # attr_accessorまたはattr_writerで実行可能
user.name # attr_accessorまたはattr_readerで実行可能
```

### クラスメソッド
インスタンスに含まれるデータを使用しない場合にクラスメソッドを使用する。

```
class クラス名
  def self.クラスメソッド
  end
end
```

または

```
class クラス名
  class << self
    def クラスメソッド
    end
  end
end
```

呼び出し方は、「クラス.メソッド名」となる。

### メソッドの表記方法
Rubyでは、インスタンスメソッドを表す際、「クラス名＃メソッド名」と書くときがある。
#=> 〇〇クラスの〇〇というインスタンスメソッド

クラスメソッドの場合、「クラス名.メソッド名」または「クラス名::メソッド名」
#=> 〇〇クラスの〇〇というクラスメソッド

### 定数
大文字で始まり、慣習的にアルファベットの大文字、数字、アンダースコアで構成される。

### selfキーワード
selfキーワードはインスタンス自身を表す。
メソッド内部では実は暗黙的にselfに対しメソッドを呼びだしている。すなわちselfは省略可能。

* selfなしの場合
* self付きの場合
* 直接インスタンス変数を参照する場合

どれも同じ結果がかえってくる。

### selfのつけ忘れに注意
セッターメソッドを呼び出す際は必ずselfが必要となる。

```
class User
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def rename_to_bob
    self.name = 'Bob'  # メソッド内でセッターメソッドを呼び出す場合はselfを必ず付ける！！
  end

  def rename_to_carol
    # self付きでname=メソッドを呼ぶ
    self.name = 'Carol'
  end

  def rename_to_dave
    # 直接インスタンス変数を書き換える
    @name = 'Dave'
  end
end
user = User.new('Alice')

# Bobにリネーム
user.rename_to_bob
user.name
#=> "Alice"

# Carolにリネーム
user.rename_to_carol
user.name
#=> "Carol"

# Daveにリネーム
user.rename_to_dave
user.name
#=> "Dave"

```

### クラスメソッドやクラス直下のself
selfは場所により、「そのクラスのインスタンスそのもの」や「クラス自身」を表す。

```
class Foo
  puts "クラス構文の直下のself: #{self}"

  def self.bar
    puts "クラスメソッド内のself: #{self}"
  end

  def baz
    puts "インスタンスメソッド内のself: #{self}"
  end
end

#=> クラス構文の直下のself: Foo #puts "クラス構文の直下のself: #{self}"のこと

Foo.bar
#=> クラスメソッド内のself: Foo

foo = Foo.new
foo.baz #=> インスタンスメソッド内のself: #<Foo:0x007f9d7c0467c8>
```
### クラスメソッドをインスタンスメソッド内で呼びだす

```
クラス名.メソッド
```

```
class Product
  attr_reader :name, :price

  def initialize(name, price)
    @name = name
    @price = price
  end

  def self.format_price(price)
    "#{price}円"
  end

  # クラス名.メソッドの形式
  # Product.format_price(price)
  # self.class.メソッドの形式
  # self.class.format_price(price)

  def to_s
    formatted_price = Product.format_price(price)
    "name: #{name}, price: #{formatted_price}"
  end
end

product = Product.new('A great movie', 1000)
product.to_s
#=> "name: A great movie, price: 1000円"
```

### クラスの継承

スーパークラス: 親クラス
サブクラス: 子クラス

単一継承: 継承できるスーパークラスは1つだけ。Rubyにおける継承はこの関係となっている。

継承の頂点は、BasicObject、それをObjectクラスが継承、その次にString, Numeric, Array, HashクラスがObjectクラスを継承している。

* 作成したクラスは宣言しただけで、Objectクラスをデフォルトで継承している。
* オブジェクトのクラスは、classメソッドを使用し確認できる。

```
class サブクラス < スーパークラス
end
```

#### superでスーパークラスのメソッドを呼び出す

superでスーパークラスの同名メソッドを呼び出すことができる。

```
class Product
  attr_reader :name, :price

  def initialize(name, price)
    @name = name
    @price = price
  end
end
product = Product.new('A great movie', 1000)
product.name
product.price

class DVD < Product
  attr_reader :running_time

  def initialize(name, price, running_time)
    # スーパークラスのinitializeメソッドを呼び出す
    super(name, price)
    @running_time = running_time
  end
end
dvd = DVD.new('A great movie', 1000, 120)
dvd.name
dvd.price
dvd.running_time

```

#### メソッドのオーバーライド
サブクラスではスーパークラスと同名のメソッドを定義することで、スーパークラスの処理を上書きできる。

#### クラスメソッドの継承
クラスを継承すると、クラスメソッドも継承される。

### メソッドの公開レベル

#### publicメソッド
クラスの外部からでも自由に呼び出せるメソッド。

#### privateメソッド
クラスの外から呼び出せず、クラス内部のみで使えるメソッド。
（レシーバを指定して呼び出すことができないメソッド）
privateメソッドではselfを使って呼び出すとエラーになる。(selfはレシーバ指定でメソッドを呼び出すから)

**privateメソッドは、サブクラスでも呼び出すことができる。**
→ privateメソッドは、そのクラス内だけでなく、サブクラスからでもprivate以下のメソッドを呼び出すことができる。

```
class << self
```
この構文でクラスメソッドをprivateにできる。

#### protectedメソッド
メソッドを定義したクラス自身と、そのサブクラスのインスタンスメソッドから、レシーバ付きで呼び出せる。

```
class User
  attr_reader :name

  def initialize(name, weight)
    @name = name
    @weight = weight
  end

  def heavier_than?(other_user)
    other_user.weight < @weight
  end

  protected

  # 同じクラスかサブクラスであればレシーバ付きで呼び出せる
  def weight
    @weight
  end
end
alice = User.new('Alice', 50)
bob = User.new('Bob', 60)

alice.heavier_than?(bob)
#=> false
bob.heavier_than?(alice)
#=> true

alice.weight
#=> NoMethodError: protected method `weight' called for #<User:0x007fbb24001ba8 @name="Alice", @weight=50>
```

### 定数について

定数はクラスの外部から直接参照が可能。

```
クラス名::定数
```

#### 再代入
定数はそのままの状態だと色々変更ができ、さらに再代入も可能。

```
class Product
  DEFAULT_PRICE = 0
  DEFAULT_PRICE = 1000
end

Product::DEFAULT_PRICE
#=> 1000

Product::DEFAULT_PRICE = 3000
#=> warning: already initialized constant Product::DEFAULT_PRICE
Product::DEFAULT_PRICE
#=> 3000
```

#### ミュータブルなオブジェクトとfreeze

```
class Product
  NAME = 'A product'
  SOME_NAMES = ['Foo', 'Bar', 'Baz']
  SOME_PRICES = { 'Foo' => 1000, 'Bar' => 2000, 'Baz' => 3000 }
end

Product::NAME.upcase!
Product::NAME
#=> "A PRODUCT"

Product::SOME_NAMES << 'Hoge'
Product::SOME_NAMES
#=> ["Foo", "Bar", "Baz", "Hoge"]

Product::SOME_PRICES['Hoge'] = 4000
Product::SOME_PRICES
#=> {"Foo"=>1000, "Bar"=>2000, "Baz"=>3000, "Hoge"=>4000}
```

freezeメソッドで定数の値を凍結する。つまり変更不可。

### 様々な変数

#### クラスインスタンス変数

クラスインスタンス変数: インスタンスの作成とは関係なく、クラス自身が持っているデータ。インスタンスメソッド内で共有されることがなく、スーパークラスやサブクラスでも共有されない。
インスタンス変数: クラス名.newでオブジェクトを作成した際に、オブジェクトごとに管理させる変数。

```
class Product
  # クラスインスタンス変数
  @name = 'Product'

  def self.name
    # クラスインスタンス変数
    @name
  end

  def initialize(name)
    # インスタンス変数
    @name = name
  end

  def name
    # インスタンス変数
    @name
  end
end
```
#### クラス変数

インスタンスメソッド内で共有され、スーパークラスやサブクラスでも共有される変数。

```
@@変数名
```

#### グローバル変数
クラスの内部外部問わず、プログラムのどこからでも変更・参照可能。

```
$変数名
```

### エイリアスメソッドの定義
独自にクラス内で作成したメソッドにも、エイリアスメソッドを定義できる。

```
alias 新しい名前 元の名前
```

```
class User
  def hello
    'Hello'
  end

  alias greeting hello
end
```

### メソッドの削除

```
undef 削除するメソッドの名前
```

### ネストしたクラスの定義

```
class 外側のクラス
  class 内側のクラス
  end
end
```

### 演算子の挙動と再定義
=で終わるメソッドを定義することができる。
=で終わるメソッドは変数に代入するような形式でそのメソッドを呼び出せる

```
class User
  def name=(value)
    @name = value
  end
end

user = User.new
user.name = 'Alice'
```

```
| ^ 6 <=> == === =~ > >= < <= << >>
+ - * / % ** - +@ -@ [] []= ` !  != !~
```
これらは再定義できる。


```
=, ?:, .., ..., not, &&, and ||, or, ::
```
これらはRubyの制御構文に組み込まれているので、再定義できない。

### 等値を判断するメソッドや演算子

* equal? object_idが等しい場合にtrue
* == オブジェクトの内容が等しいか判断
* eql? ハッシュのキーとして2つのオブジェクトが等しいか判断
* === 主にcase, whenで使われる。

### オープンクラス
Rubyのクラスは、変更に対してオープン（つまりクラスの継承などに制限がない）なので「オープンクラス」と呼ばれたりする。
Railsでは、オープンクラスを活用し、標準のRubyにはない様々な便利メソッドを独自定義している。

### モンキーパッチ
新しいメソッドを追加するだけでなく、既存のメソッドを上書きすることもできる。
既存の実装を上書きし、自分が期待する挙動に変更することを「モンキーパッチ」と呼ぶ。

```
class User
  def initialize(name)
    @name = name
  end

  def hello
    "Hello, #{@name}!"
  end
end

user = User.new('Alice')
user.hello #=> "Hello, Alice!"

# helloメソッドにモンキーパッチを適応
class User
  def hello
    "#{@name}さん、こんにちは！"
  end
end

user.hello
#=> "Aliceさん、こんにちは！"
```

### 特異メソッド
特定のオブジェクトだけに紐づくメソッドのこと。
クラスメソッドも一種の特異メソッド。（公式はクラスメソッド　＝　特異メソッドという見解）
RubyではStringやUser

```
alice = 'I am Alice.'
bob = 'I am Bob.'

# aliceのオブジェクトにだけ、shuffleメソッドを定義する
def alice.shuffle
  chars.shuffle.join
end

alice.shuffle
#=> "m le a.icIA"
bob.shuffle
```

### ダックタイピング
オブジェクトがなんであろうとそのメソッドがよびだせればOKとするプログラミングスタイルのこと。

```
def display_name(object)
  puts "Name is <<#{object.name}>>"
end

class User
  def name
    'Alice'
  end
end

class Product
  def name
    'A great movie'
  end
end

# UserクラスとProductクラスはお互いに無関係なクラス、しかしdisplay_nameメソッドは実行可能
user = User.new
display_name(user)
#=> Name is <<Alice>>

product = Product.new
display_name(product)
#=> Name is <<A great movie>>
```

### respond_to?
オブジェクトに対して得意のメソッドが呼び出し可能か確認するメソッド

### メソッドのオーバーロード（多重定義）
Rubyではオーバーロードはない。
オーバーロード: 引数のデータ型や個数の違いに応じて同じ名前のメソッドを何個も定義できるというもの。