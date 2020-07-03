use "ponytest"
use ".."

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)
  new make () =>
    None
  fun tag tests(test: PonyTest) =>
    test(_TestMurmur32)
class iso _TestMurmur32 is UnitTest
  fun name(): String => "Testing Murmur 32"
  fun apply(t: TestHelper) =>
    try
      var hash: U32 = Murmur32.hash("test".array())?
      t.assert_true(hash == 3127628307)
      hash = Murmur32.hash("linus".array())?
      t.assert_true(hash == 2202938615)
      hash = Murmur32.hash("murmur".array())?
      t.assert_true(hash == 1945310157)
      hash = Murmur32.hash("veni, vidi, vici".array())?
      t.assert_true(hash == 1945310157)
      t.log(hash.string())
    else
      t.fail("Error during hashing")
    end
