PNC_SRC = programnode-translator

programnode-translator-fetch:
	@fetch $(FETCH_OPTION) \
		"[dict(git='git@github.com:mapleelpam/programnode-translator.git', revision='master')]"

programnode-translator-build:
	cd $(PNC_SRC) && ./build.sh
#	mkdir build -p
#	cd build 
#	cmake ..
#	$(MAKE) 

programnode-translator-install:

programnode-translator-clean:
	$(MAKE) -C $(BOOST_SRC) clean
	rm -fr $(BUILD_DIR)/programnode-translator
