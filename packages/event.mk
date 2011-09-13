EVENT_VERSION := 2.0.13-stable
EVENT_SRC := libevent-$(EVENT_VERSION)

event-fetch:
	@fetch $(FETCH_OPTION) "[dict(url='http://monkey.org/~provos/libevent-2.0.13-stable.tar.gz', sha1sum='3c467f7eac2d38986a378311815b980e325a97d5')]"

event-build:
	if [ ! -f $(EVENT_SRC)/config.h ]; then \
			cd $(EVENT_SRC) && chmod +x ./configure && ac_cv_va_copy=1 sh ./configure --with-java=no --with-python=no --with-csharp=no --with-erlang=no --host=$(HOST) --prefix=/; \
	fi
	$(MAKE) $(SMP_MFLAGS) -C $(EVENT_SRC)
	mkdir -p $(LIB_DIR) && cp -af $(EVENT_SRC)/.libs/libevent*.a $(LIB_DIR)/
	mkdir -p $(INCLUDE_DIR) && cp -af $(EVENT_SRC)/evdns.h $(EVENT_SRC)/include/event2/event-config.h $(EVENT_SRC)/event.h $(EVENT_SRC)/evhttp.h $(EVENT_SRC)/evrpc.h $(EVENT_SRC)/evutil.h $(INCLUDE_DIR)

event-clean:
	if [ -f $(EVENT_SRC)/Makefile ]; then \
		$(MAKE) -C $(EVENT_SRC) distclean; \
	fi
	rm -f $(EVENT_SRC)/config.h

event-install:
	mkdir -p $(TARGET_LIB_DIR) && cp -af $(EVENT_SRC)/.libs/libevent.so* $(TARGET_LIB_DIR)/
