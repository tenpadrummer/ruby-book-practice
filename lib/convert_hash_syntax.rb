def convert_hash_syntax(old_syntax)
  # gsubメソッドの第二引数で書かれた\1は1番目にキャプチャされた文字列を表す。
  # "name"や"age"がここに入る、その一方:は単なる文字列なので、文字列として出力される。
  old_syntax.gsub(/:(\w+) *=> */, '\1: ')
end