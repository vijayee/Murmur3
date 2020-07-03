build:
	mkdir -p build
test: build
	mkdir -p build/test
test/Murmur3: test Murmur3/test/*.pony
	ponyc Murmur3/test -o build/test --debug
test/execute: test/Murmur3
	./build/test/test
clean:
	rm -rf build

.PHONY: clean test
