BOOST_SRC = boost

boost-fetch:
	@fetch $(FETCH_OPTION) \
		"[dict(git='git://github.com/mapleelpam/boost.git', \
		revision='master')]"

boost-build:
	$(MAKE) -C $(BOOST_SRC)

boost-install:

boost-clean:
	$(MAKE) -C $(BOOST_SRC) clean
	rm -fr $(BUILD_DIR)/boost
