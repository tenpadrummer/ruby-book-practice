require 'minitest/autorun' # プログラム内でMinitestを使えるようにするためのコード
require './lib/fizz_buzz' # require_relative '../lib/fizz_buzz'

class SampleTest < Minitest::Test # Minitest::Testクラスを継承
  def test_sample
    assert_equal '1', fizz_buzz(1)
    assert_equal '2', fizz_buzz(2)
    assert_equal 'Fizz', fizz_buzz(3)
    assert_equal '4', fizz_buzz(4)
    assert_equal 'Buzz', fizz_buzz(5)
    assert_equal 'Fizz', fizz_buzz(6)
    assert_equal 'Fizz Buzz', fizz_buzz(15)
  end
end