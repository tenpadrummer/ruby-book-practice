## Ruby on Railsについて

### 開発に必要な知識

1. アプリケーション設計
  * MVC
  * REST
  * デザインパターン
2. Web技術
  * TCP/IP,HTTP
  * websocket
  * SSl/HTTPS
  * HTML
    - ERB
    - HAML
  * JS
  * Ajax
  * CSS
    - Sass
    - LESS
3. DB
  * SQL
  * テーブル結合
  * テーブル作成
  * テーブル関連
  * インデックス
  * 主キー, 外部キー
  * 制約(ユニーク制約, NOTNULLなど)
  * トランザクション
  * NUllと3値論理
  * DB設計の原則
  * (スキーマ、マイグレーション、アソシエーション、クエリインターフェース)
4. セキュリティ（SQLインジェクションなど）
5. テストの自動化
6. GitとGithub
7. サーバ運用
  * セットアップ
  * DNS管理
  * デプロイの自動化
  * サーバの監視
  * サーバのチューニング
  * データのバックアップ
  * AWS

### GemとBundler
gem: Rubyのライブラリ。RubyGemsというサイトにアップロード・ダウンロード可能。

rbenvなどでrubyを管理している場合、rubyのバージョンゴットにgemをインストールする必要がある。
またgemの中にはC言語向けの外部ライブラリを利用するものもある。
gemによっては他のgemを利用するため、依存関係が存在する。

bundler: gemの依存関係やgemそのものを管理するgem。
Gemfile: Rubyを使用したDSL。
bundle exec: bundlerが管理する依存関係の中でRubyのプログラムが実行される。

### Gemfileに記載する記号の意味

```
# バージョンはBundlerにおまかせ
gem 'faker'

# 1.7.2に固定
gem 'faker', '1.7.2'

# 1.7.2以上（上は制限なし）
gem 'faker', '>= 1.7.2'

# 1.7.2以上かつ1.8未満（1.7.11などは良いが、1.8.0はNG）
gem 'faker', '~> 1.7.2'

# 1.7以上かつ2.0未満（1.9.0などは良いが、2.0.0はNG）
gem 'faker', '~> 1.7'
```