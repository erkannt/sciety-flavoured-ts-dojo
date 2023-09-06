.PHONY: check clean clobber watch-typescript

MK_LINTED_TS := .mk-linted-ts
MK_TESTED_TS := .mk-tested-ts
TS_SOURCES := $(shell find src test -name '*.ts')
LINT_CACHE := .eslint-cache

check: $(MK_TESTED_TS) $(MK_LINTED_TS)

$(MK_LINTED_TS): node_modules $(TS_SOURCES)
	npx eslint . \
		--ext .js,.ts \
		--cache --cache-location $(LINT_CACHE) \
		--color --max-warnings 0
	npx madge --circular --extensions ts src test
	npx ts-unused-exports tsconfig.json --silent
	@touch $@

$(MK_TESTED_TS): node_modules $(TS_SOURCES)
	npx jest
	@touch $@

clean:
	rm -rf $(MK_LINTED_TS) $(MK_TESTED_TS)
	rm -rf $(LINT_CACHE)
	$(MAKE) -C $(GRAPH_DIR) clean

clobber: clean
	rm -rf build node_modules

node_modules: package.json
	npm install
	touch node_modules

watch-typescript: node_modules
	npx tsc --watch --no-emit
