## その他のRubyとライブラリ

### 日付と時刻のライブラリ

* Timeクラス
* Dateクラス
* DateTimeクラス

### ファイルやディレクトリのライブラリ

* Fileクラス
* Dirクラス
* FileUtilsクラス
* Pathnameクラス

### 特定ファイルの読み書き用ライブラリ

* CSVクラス
* JSONクラス: JSと互換性のあるテキストフォーマット
* YAMLクラス: インデントを使ってデータの階層構造を表現するテキストフォーマット

### 環境変数や起動時引数

* 組み込み定数(ENV, ARGV)
  * ENV: 環境変数を格納する定数
  * ARGV: 起動時引数を格納する定数

### eval, バッククォートリテラル, sendメソッド

* evalメソッド: 受け取った文字列をRubyのコードとして実行。
* バッククォートリテラル: バッククォートで囲まれた文字列をOSコマンドとして実行。
* sendメソッド: レシーバに対して指定した文字列(またはシンボル)のメソッドを実行。

### ツールを使ったコードレビュー(rails用)

* Brakeman
* Rubocop
* RubyCritic

### Rake
Rubyで作られたビルドツール。
上記にかぎらず「何かしらのまとまった処理（=タスク）」を簡単に実行するためのツールでもある。

#### 特徴
* Rubyプログラムを内部DSlとして使用する。RakeはRakefileにタスクを定義する。
* よく使われるいくつかのタスクをあらかじめ用意している。

※DSL: "Domain Specific Language", ドメイン固有言語のこと。
= 何か特別な目的を実現するために定義された、人間に読みやすく、機械に処理をしやすいテキストファイルの記述ルールのこと。
