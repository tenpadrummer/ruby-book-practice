## デバッグ技法

### バックトレースとは
プログラムの実行でエラー（例外）が発生すると表示（出力）される。
→ ターミナル、ブラウザ、ログファイルなど。

### よく発生する例外クラスとその原因

#### NameError
未定義のローカル変数や定数、privateメソッドを呼び出すと発生。

* タイポが多い。

#### NoMethodError
存在しないメソッドを呼び出そうとすると発生。

* 単純にメソッド名を打ち間違えた。
* レシーバの型（クラス）が想定していた型と異なる。
* レシーアがnilになっている。

#### TypeError
期待しない型（クラス）がメソッドの引数に渡ると発生。

#### ArgumentError
引数の値の数が違う、期待する値ではないと発生。

#### ZeroDivisionError
整数を0mで除算しようとすると発生。

#### SystemStackError
システムスタックが溢れた時に発生。誤ってメソッドを再帰呼び出しした場合によく起きる。

```

class User
  # def name=(name) が正解
  def name
    @name = name
  end
end
user = User.new
user.name
#=> SystemStackError: stack level too deep
```

#### LoadError
requireやloadの実行に失敗した時に発生。

* requireしたいファイルのパスやライブラリ名が誤っている。
* requireしたいgemが実行環境にインストールされていない。

#### SyntaxError
構文エラー。endやカンマの数に過不足がある、括弧が正しく閉じれていない、など。

### Rubyの途中デバッグ

#### printデバッグ
print文をプログラムに埋め込み、ターミナルに出力される値を確認する手法。
puts, pでも同様のことが行える。
このデバッグは、変数やメソッドの出力だけでなく、メソッドや条件分岐が正常に実行されたかの確認にも使われる。

#### tapメソッド
tapメソッド: ブロック引数にレシーバをそのまま渡す。

```
# メソッドチェーンを使っているこのコードをデバッグしたい
'#043c78'.scan(/\w\w/).map(&:hex)

# tapメソッドを使って、scanメソッドの戻り値をターミナルに表示する
'#043c78'.scan(/\w\w/).tap { |rgb| p rgb }.map(&:hex)
#=> ["04", "3c", "78"]
```

#### ログに出力する
loggerを使用する。

```
class User < ApplicationRecord
  def facebook_username
    info = facebook_auth.auth_info.info
    # ログに変数info,nicknameの値を出力する
    logger.debug "[DEBUG] info.name : #{info.name}"
    info.nickname
  end
end
```

#### デバッガを使用する
Byebug: Rubyのデバッガツール。これにより対話的にデバッグが可能となる。

コマンド一覧: https://github.com/deivid-rodriguez/byebug

### その他のデバッグ手法

* irbで簡単なコードを動かしてみる
* ログを調べる
* 公式ドキュメントを読む
* issueを検索する
* ライブラリのコードを読む
* テストコードを書く
* ネットの情報を参照する（ただし注意しながら調べる）
* PCから離れる
* 誰かに聞く