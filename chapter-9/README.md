## 例外処理

### 例外とは
プログラムの実行中に発生した、例外的な問題。
→ エラーが起きてプログラムの実行を続けることができなくなった状態のこと。

* 意図的にエラーを出し、プログラムを実行させることも可能
* プログラムが続行できない異常事態として、意図的に例外を発生させることもできる。

### 例外の捕捉

#### 発生した例外を補足しない
バックトレース（スタックトレース）: プログラムの実行過程のこと。

```
puts 'Start.'
module Greeter
  def hello
    'hello'
  end
end
greeter = Greeter.new
# 上の行で例外が発生するため、ここから下は実行されない
puts 'End.'
```

#### 例外を捉え処理を続行する

```
begin
  例外が起きうる処理
rescue
  例外が発生した場合の処理
end
```

```
puts 'Start.'
module Greeter
  def hello
    'hello'
  end
end

# 例外処理を組み込んで例外に対処する
begin
  greeter = Greeter.new
rescue
  puts '例外が発生したが、このまま続行する'
end

# 例外処理を組み込んだので、最後まで実行可能
puts 'End.'
```

### 例外処理のながれ

```
def method_1
  puts 'method_1 start.'
  begin
    method_2
  rescue
    puts '例外が発生しました'
  end
  puts 'method_1 end.'
end

def method_2
  puts 'method_2 start.'
  method_3
  puts 'method_2 end.'
end

def method_3
  puts 'method_3 start.'
  # ZeroDivisionErrorを発生させる
  1 / 0
  puts 'method_3 end.'
end

1. method_1を実行すると、puts 'method_1 start.'を表示。
2. beginの中でmethod_2を呼び出す。
3. method_2内のputs 'method_2 start.'を表示。
4. method_3を呼び出し、puts 'method_3 start.'を表示。
5. 1 / 0を行うと、ZeroDivisionErrorがでるので、method_1のrescueに戻る。
6. puts '例外が発生しました'が表示され、puts 'method_1 end.'が出て終了。

```

### 例外オブジェクトから情報取得

```
begin
  例外が起きうる処理
rescue => 例外オブジェクトを格納する変数
  例外が発生した場合の処理
end
```

```
begin
  1 / 0
rescue => e
  puts "エラークラス: #{e.class}"
  puts "エラーメッセージ: #{e.message}"
  puts "バックトレース -----"
  puts e.backtrace
  puts "-----"
end
```

### クラス指定で補足する例外を限定

```
begin
  例外が起きうる処理
rescue 捕捉したい例外クラス
  例外が発生した場合の処理
end
```

```
begin
  'abc'.foo #これがあるのでNoMethodErrorのrescueへ
rescue ZeroDivisionError
  puts "0で除算しました"
rescue NoMethodError
  puts "存在しないメソッドが呼び出されました"
end
#=> 存在しないメソッドが呼び出されました

begin
  'abc'.foo
rescue ZeroDivisionError, NoMethodError => e
  puts "0で除算したか、存在しないメソッドが呼び出されました"
  puts "エラー: #{e.class} #{e.message}"
end
```

### rubyにおける例外クラスの継承関係

Exceptionクラス: 全ての例外の頂点

StandardError: Exceptionクラスを継承。通常のプログラムで発生しうるスーパークラス
特殊なエラー(SystemExitなど): Exceptionクラスを継承。
ScriptError: Exceptionクラスを継承。SyntaxErrorやLoadError。

RuntimeError: StandardErrorのサブクラス
NameError: StandardErrorのサブクラス
TypeError: StandardErrorのサブクラス
ArgumentError: StandardErrorのサブクラス
その他の例外クラス: StandardErrorのサブクラス

NoMethodError: StandardErrorのサブクラスであるNameErrorを継承。

### 例外クラスの継承関係とrescueの順番について

rescueは上から順番に実行される。
したがって例外クラスをしている場合、その継承関係に注意してrescueを書く必要がある。

(最後にStandardErrorクラスを指定すればまとめて捕捉可能。)

### retry
例外処理において、もう一度処理をやりなおす「retry」をrescueで実行すると、beginからやり直せる。

```
retry_count = 0
begin
  puts '処理を開始します。'
  # わざと例外を発生させる
  1 / 0
rescue
  retry_count += 1
  if retry_count <= 3
    puts "retryします。（#{retry_count}回目）"
    retry
  else
    puts 'retryに失敗しました。'
  end
end

#=> 処理を開始します。
#   retryします。（1回目）
#   処理を開始します。
#   retryします。（2回目）
#   処理を開始します。
#   retryします。（3回目）
#   処理を開始します。
#   retryに失敗しました。
```

### 意図的な例外の発生
raiseメソッド: コードの中で意図的に発生させられる。

```
def currency_of(country)
  case country
  when :japan
    'yen'
  when :us
    'dollar'
  when :india
    'rupee'
  else
    # 意図的に例外を発生させる
    raise "無効な国名です。#{country}"
  end
end

currency_of(:japan)
#=> "yen"
currency_of(:italy)
#=> RuntimeError: 無効な国名です。italy
```

### 例外処理のベストプラクティス
セオリー:「機能としては確かに用意されている、しかしそれを使うべき時と使わない時、それぞれを区別しなければならない」

#### 安易にrescueしない
「例外が発生したら即座にrescueする」→ ×
「例外が発生したらすぐに異常終了する」→ ○
「フレームワークの共通処理に丸投げする」→ ○

#### rescueしたら情報を残すこと
原則: 例外が発生したらrescueしない。

原因救命のため、例外をrescueでその時の状況を記録に残す。（クラス名、エラーメッセージ、バックトレース）

```
users.each do |user|
  begin
    send_mail_to(user)
  rescue => e
    # 例外のクラス名、エラーメッセージ、バックトレースをターミナルに出力
    # （ログファイルがあればそこに出力する方がベター）
    puts "#{e.class}: #{e.message}"
    puts e.backtrace
  end
end
```

#### 例外処理の対象範囲と対象クラスを絞り込む
例外が発生しそうな箇所と発生しそうな例外クラスをあらかじめ予想し、その予想を例外処理に反映させること。

```
def convert_heisei_to_date(heisei_text)
  m = heisei_text.match(/平成(?<jp_year>\d+)年(?<month>\d+)月(?<day>\d+)日/)
  year = m[:jp_year].to_i + 1988
  month = m[:month].to_i
  day = m[:day].to_i
  # 例外処理の範囲を狭め、捕捉する例外クラスを限定する
  begin
    Date.new(year, month, day)
  rescue ArgumentError
    # 無効な日付であればnilを返す
    nil
  end
end

convert_heisei_to_date('平成28年12月31日')
#=> #<Date: 2016-12-31 ((2457754j,0s,0n),+0s,2299161j)>
convert_heisei_to_date('平成28年99月99日')
#=> nil
```

#### 例外処理より条件分岐
begin ~ rescueを使うより条件分岐を使った方が可読性およびパフォーマンスが上がる。

#### 予想しない条件は異常終了へ
case, when節では、どんなパターンかわかりやすいため、
whenでは想定可能なパターンを推測、elseでは「想定不可」のパターンを記載。

```
def currency_of(country)
  case country
  when :japan
    'yen'
  when :us
    'dollar'
  when :india
    'rupee'
  else
    raise ArgumentError, "無効な国名です。#{country}"
  end
end
# 例外が発生する
currency_of(:italy)
#=> ArgumentError: 無効な国名です。italy
```

### 文字入力のメソッド(Kernelモジュールのメソッド)
gets: 文字入力を受け付けるメソッド
chomp: 改行文字を削除するメソッド

### 例外処理について

#### ensure
例外が発生してもしなくても実行したい処理がある場合にensureメソッド
※ensureではreturnは使用しない！

```
begin
  # 例外が発生するかもしれない処理
rescue
  # 例外発生時の処理
ensure
  # 例外の有無に関わらず実行する処理
end
```

#### 例外処理のelse

```
begin
  # 例外が発生するかもしれない処理
rescue
  # 例外発生時の処理
else
  # 例外発生しなかった場合の処理
ensure
  # 例外の有無に関わらず実行する処理
end
```

#### 例外処理と戻り値

```
# 正常に終了した場合
ret =
  begin
    'OK'
  rescue => e
    'error'
  ensure
    'ensure'
  end
ret #=> "OK"

# 例外が発生した場合
ret =
  begin
    1 / 0
    'OK'
  rescue => e
    'error'
  ensure
    'ensure'
  end
ret
#=> "error"
```

#### rescue修飾子 (begin/endを省略)

```
例外が発生しそうな処理 rescue 例外が発生した時の戻り値
```

```
def to_date(string)
  Date.parse(string) rescue nil
end

to_date('2017-01-01')
#=> #<Date: 2017-01-01 ((2457755j,0s,0n),+0s,2299161j)>
to_date('abcdef')
#=> nil
```

#### $!と$@に格納される例外処理

```
# 組み込み変数に格納された例外情報を使う
begin
  1 / 0
rescue
  puts "#{$!.class} #{$!.message}"
  puts $@
end
```

#### begin/endの省略ケース

```
def fizz_buzz(n)
  if n % 15 == 0
    'Fizz Buzz'
  elsif n % 3 == 0
    'Fizz'
  elsif n % 5 == 0
    'Buzz'
  else
    n.to_s
  end
rescue => e
  puts "#{e.class} #{e.message}"
end

fizz_buzz(nil)
#=> NoMethodError undefined method `%' for nil:NilClass
```

#### rescueした例外を再発生させる

rescueの中でもraiseメソッドを使用できる。

```
def fizz_buzz(n)
  if n % 15 == 0
    'Fizz Buzz'
  elsif n % 3 == 0
    'Fizz'
  elsif n % 5 == 0
    'Buzz'
  else
    n.to_s
  end
rescue => e
  puts "[LOG] エラーが発生しました: #{e.class} #{e.message}"
  # 捕捉した例外を再度発生させ、プログラム自体は異常終了
  raise
end

fizz_buzz(nil)
#=> [LOG] エラーが発生しました: NoMethodError undefined method `%' for nil:NilClass
#   NoMethodError: undefined method `%' for nil:NilClass
```

#### 独自の例外クラス

```
class NoCountryError < StandardError
  # 機能的にはStandardErrorと同じなので、実装コードは特に書かない
end

def currency_of(country)
  case country
  when :japan
    'yen'
  when :us
    'dollar'
  when :india
    'rupee'
  else
    raise NoCountryError, "無効な国名です。#{country}"
  end
end

currency_of(:italy)
#=> NoCountryError: 無効な国名です。italy
```