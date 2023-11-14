default: test

.PHONY: deps
deps:
	mix deps.get

.PHONY: build
build: deps
	mix compile

.PHONY: test
test: build
	mix test

.PHONY: repl
repl: build
	iex -S mix
