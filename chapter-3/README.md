## Rubyテストの自動化

### 「プログラミングの三大美徳」
怠惰 怠け者: 全体の労力を減らす手間（プログラムの作成やコードの改善）を惜しまない気質
短期 気が短い: コンピュータの動作が怠慢(プログラムの質が悪い)な時に感じる怒り
傲慢 自信過剰: 自分の書いたプログラムは誰に見せても恥ずかしくないと胸をはって言える自尊心

### minitest
テスティングフレームワーク。
【メリット】
* Rubyのインストールと同時にインストールされる。セットアップ不要。
* 学習コストが低い。
* Railsのデフォルトテスティングフレームワークなので、Railsにも活かしやすい。

#### minitestにおけるテストの自動化
1. テスティングフレームワークのルールに沿ってプログラム実行結果を検証するプログラムを書く。
2. テストコードを実行する。
3. 実行結果をチェックし、その結果が正しいか間違っているか報告する。

#### 検証メソッド
* assert_equal b, a (aがbと等しければパス)
* assert a (aが真であればパス)
* refuse a (aが偽であればパス)

### テスティングフレームワーク
* Minitest: 上記記載済み。
* RSpec: 独自のDSL（ドメイン固有言語）を使ったテスト。
* test-unit: もっとも古く、Ruby本体のテストコードはtest-unitを採用している。