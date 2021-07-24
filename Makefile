
run:
	clear
	swift build
	swift run

local:
	python3 -m http.server
	open http://localhost:8000
