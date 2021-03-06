def to_hex(r,g,b)
  [r,g,b].inject("#") do |hex, n|
    hex + n.to_s(16).rjust(2, "0")
  end
end

# DRY原則・・・"don't repeat yourself"の略。「繰り返しを避けること」をさす。
# 最小の繰り返し処理ではhexに"#"が代入されている。
# ブロックの中にhex + n.to_s(16).rjust(2, "0")で作成された文字列は、次の繰り返しのhexに代入される。
# 繰り返し処理が最後まで到着したら、ブロックの戻り値がinjectメソッド自身の戻り値となる。

def to_ints(hex)
  r = hex[1..2]
  g = hex[3..4]
  b = hex[5..6]
  [r, g, b].map do |s|
    s.hex
  end
end

# hexメソッドはStringクラスに用意されたメソッド。16進数の文字列を10進数の整数に変換する。
# 引数の文字列から3つの16進数を抜き出す。
# 3つの16進数を配列に入れ、ループを回しながら10進数の整数に変換した値を別の配列に詰め込む。
# 10進数の整数が入った配列を返す。

# 上級リファクタ
# def to_ints(hex)
#   hex.scan(/\w\w/).map(&:hex)
# end
# 正規表現にマッチした文字列を配列として返すscanメソッドを使用。これにより一気に文字列を3つの16進数に分割。
# ブロック引数が１つだけ
# ブロックの中で呼び出すメソッドには引数がない。
# ブロックの中では、ブロック引数に対してメソッドを１回呼び出す以外の処理がない
# 上記3つを満たすので「&:」を使用している。