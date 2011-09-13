THRIFT_VERSION := 0.7.0
THRIFT_SRC := thrift-$(THRIFT_VERSION)

thrift-fetch:
	@fetch $(FETCH_OPTION) "[dict(url='http://ftp.mirror.tw/pub/apache//thrift/0.7.0/thrift-0.7.0.tar.gz', sha1sum='b8f6877bc75878984355da4efe171ad99ff05b6a')]"
	rm -f $(THRIFT_SRC)/config.h

thrift-build:
	if [ ! -f $(THRIFT_SRC)/config.h ]; then \
			cd $(THRIFT_SRC) && chmod +x ./configure && ac_cv_va_copy=1 sh ./configure --with-java=no --with-python=no --with-csharp=no --with-erlang=no --host=$(HOST) --prefix=/; \
	fi
	$(MAKE) $(SMP_MFLAGS) -C $(THRIFT_SRC)
	mkdir -p $(LIB_DIR) && cp -af $(THRIFT_SRC)/lib/cpp/.libs/libthrift.so* $(LIB_DIR)/
	#mkdir -p $(INCLUDE_DIR) && cp -af $(THRIFT_SRC)/popt.h $(INCLUDE_DIR)/

thrift-clean:
	if [ -f $(THRIFT_SRC)/Makefile ]; then \
		$(MAKE) -C $(THRIFT_SRC) distclean; \
	fi
	rm -f $(THRIFT_SRC)/config.h

thrift-install:
	mkdir -p $(TARGET_LIB_DIR) && cp -af $(THRIFT_SRC)/.libs/libpopt.so* $(TARGET_LIB_DIR)/
