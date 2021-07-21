

run: 
	swift build
	swift run

embed:
	git clone https://github.com/apple/swift.git
	./swift/utils/update-checkout --clone
	./swift/utils/build-parser-lib --release --no-assertions --build-dir /tmp/parser-lib-build