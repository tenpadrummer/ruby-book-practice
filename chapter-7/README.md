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
