## yieldとProc

### yield
yieldは基本ブロックを呼びだす。
yieldはブロックに引数を渡したり、ブロックの戻り値を受け取ったりできる。

```
def greeting
  puts 'おはよう'
  # 引数を2つ渡す
  text = yield 'こんにちは', 12345
  puts text
  puts 'こんばんは'
end

greeting do |text|
  # ブロック引数が1つであれば、2つ目の引数は無視される
  text * 2
end
#=> おはよう
#   こんにちはこんにちは
#   こんばんは


def greeting
  puts 'おはよう'
  # 引数を1つ渡す
  text = yield 'こんにちは'
  puts text
  puts 'こんばんは'
end

greeting do |text, other|
  # ブロック引数が2つであれば、2つ目の引数はnilになる
  text * 2 + other.inspect
end
#=> おはよう
#   こんにちはこんにちはnil
#   こんばんは

```

### callメソッド
引数の名前は自由。

```
def メソッド(&引数)
  引数.call
end
```

```
def greeting(&block)
  puts 'おはよう'
  # ブロックが渡されていなければblockはnil
  unless block.nil?
    text = block.call('こんにちは')
    puts text
  end
  puts 'こんばんは'
end

# ブロック無しで呼び出す
greeting
#=> おはよう
#   こんばんは

# ブロック付きで呼び出す
greeting do |text|
  text * 2
end
#=> おはよう
#   こんにちはこんにちは
#   こんばんは
```

```
def greeting(&block)
  puts 'おはよう'
  # 引数のblockを使わずにblock_given?やyieldも使用可
  if block_given?
    text = yield 'こんにちは'
    puts text
  end
  puts 'こんばんは'
end
```

### ブロックを引数に渡すメリット
* ブロックを他のメソッドに引き渡せるようになること。
他のメソッドにブロックを渡す場合、引数の手前に&をつける。
(&がないとブロックではなく、ただの引数となる)

* 渡されたブロックに対しメソッドを呼びだし、必要な情報を取得したりブロックへ何かしらの操作を実行できるようになる。

arityメソッド: ブロック引数の個数を確認できる。

### Procオブジェクト
Procクラスはブロックをオブジェクト化するクラス
Procクラスはブロック、つまり「何らかの処理」を表す。
Proc.newで作成可能。procでも作成できる。
Procオブジェクトはcallメソッドで実行可能。

```
# "Hello!"という文字列を返すProcオブジェクト
hello_proc = Proc.new { 'Hello!' }
hello_proc.call
#=> "Hello!"
```

### Procオブジェクトの様々な渡し方

#### ブロックの代わり

```
def greeting(&block)
  puts 'おはよう'
  text = block.call('こんにちは')
  puts text
  puts 'こんばんは'
end

# Procオブジェクトを作成し、それをブロックの代わりとしてgreetingメソッドに渡す
repeat_proc = proc { |text| text * 2 }
greeting(&repeat_proc)
#=> おはよう
#   こんにちはこんにちは
#   こんばんは
```

#### 普通の引数として

```
# 3種類のProcオブジェクトを受け取り、それぞれのあいさつ文字列に適用するgreetingメソッド
def greeting(proc_1, proc_2, proc_3)
  puts proc_1.call('おはよう')
  puts proc_2.call('こんにちは')
  puts proc_3.call('こんばんは')
end

shuffle_proc = proc { |text| text.chars.shuffle.join }
repeat_proc = proc { |text| text * 2 }
question_proc = proc { |text| "#{text}?" }

# 3種類のProcオブジェクトをgreetingメソッドに渡す
greeting(shuffle_proc, repeat_proc, question_proc)
#=> はおうよ
#   こんにちはこんにちは
#   こんばんは?
```

### Procオブジェクトを実行する様々な方法

```
add_proc = Proc.new { |a, b| a + b }

# callメソッド
add_proc.call(10, 20)
#=> 30
# yieldメソッド
add_proc.yield(10, 20)
#=> 30
# .()
add_proc.(10, 20)
#=> 30
# []
add_proc[10, 20]
#=> 30
# ===, case文のwhen節でProcオブジェクトを使えるようにするため。
add_proc === [10, 20]
#=> 30
```