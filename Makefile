
run:
	clear
	swift build
	swift run > web/src/graph.json
#	swift run | python -m json.tool

local:
	python3 -m http.server
	open http://localhost:8000
