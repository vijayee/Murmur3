use "collections"
primitive ROTL32
  fun apply(m: U32, n: U32): U32 =>
    (m << n) or (m >> (32 - n))

primitive Murmur32
  fun apply(data: Array[U8] box, seed: U32 = 0): Array[U8] ref^ ? =>
    var hash': U32 = hash(data, seed)?
    var littleEndian: Array[U8] ref^ = Array[U8].init(0, 4)
    var shift: USize = 0
    for i in Range(0, 4) do
      shift =  8 * i
      littleEndian(i)? = ((hash' >> shift.u32()) and 0xFF).u8()
    end
    littleEndian

  fun hash(data: Array[U8] box, seed: U32 = 0): U32 ? =>
    let blockLen: USize = data.size() / 4
    var hash': U32 = seed

    var i: USize = 0
    while i < blockLen do
      var block: U32 =  data(i)?.u32() or (data(i+1)?.u32() << 8) or (data(i+2)?.u32() << 16) or (data(i+3)?.u32() << 24)
      block = block * 0xcc9e2d51
      block = ROTL32(block, 15)
      block = block * 0x1b873593
      hash' = hash' xor block
      hash' = ROTL32(hash', 13)
      hash' = (hash' * 5) + 0xe6546b64
      i = i + 1
    end


    let remainder: U32 = (data.size() % 4).u32()
    var k : U32 = 0
    if remainder == 3 then
      k = k xor (data((blockLen * 4) + 2)?.u32() << 16)
    end
    if remainder >= 2 then
      k = k xor (data((blockLen * 4) + 1)?.u32() << 8)
    end
    if remainder >= 1 then
      k = k xor data(blockLen * 4)?.u32()
      k = k * 0xcc9e2d51
      k = ROTL32(k, 15)
      k =  k * 0x1b873593
      hash' = hash' xor k
    end

    hash' = hash' xor data.size().u32()
    hash' = hash' xor (hash' >> 16)
    hash' = hash' * 0x85ebca6b
    hash' = hash' xor (hash' >> 13)
    hash' = hash' * 0xc2b2ae35
    hash' = hash' xor (hash' >> 16)
    hash'

primitive Murmur128
