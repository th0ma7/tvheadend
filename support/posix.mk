MAN = $(ROOTDIR)/man/tvheadend.1
ICON = $(ROOTDIR)/support/gnome/tvheadend.svg

INSTICON= ${DESTDIR}$(prefix)/share/icons/hicolor/scalable/apps


install: ${PROG} ${MAN}
	install -d ${DESTDIR}${bindir}
	install ${PROG} ${DESTDIR}${bindir}/tvheadend
	install support/tvhmeta ${DESTDIR}${bindir}/tvhmeta
	install lib/py/tvh/tv_meta_tmdb.py ${DESTDIR}${bindir}/tv_meta_tmdb.py
	install lib/py/tvh/tv_meta_tvdb.py ${DESTDIR}${bindir}/tv_meta_tvdb.py
ifeq ($(CONFIG_IMAGECACHE_AUDIT),yes)
# Developer tool, not installed by default (run it from support/ instead).
# --enable-imagecache_audit installs it with the configured localstatedir baked
# in as its config-dir fallback (for packaged installs with non-standard paths).
	sed 's|@TVHEADEND_LOCALSTATEDIR@|${localstatedir}|' support/tv_imagecache_audit.py > ${DESTDIR}${bindir}/tv_imagecache_audit.py
	chmod 0755 ${DESTDIR}${bindir}/tv_imagecache_audit.py
endif
	install -d ${DESTDIR}${mandir}/man1
	install ${MAN} ${DESTDIR}${mandir}/man1/tvheadend.1

	for bundle in ${BUNDLES}; do \
		mkdir -p ${DESTDIR}${datadir}/tvheadend/$$bundle ;\
		cp -LR $(ROOTDIR)/$$bundle/*  ${DESTDIR}${datadir}/tvheadend/$$bundle ;\
	done

	find ${DESTDIR}${datadir}/tvheadend -name .git -exec rm -rf {} \; &>/dev/null || /bin/true

uninstall:
	rm -f ${DESTDIR}${bindir}/tvheadend
	rm -f ${DESTDIR}${mandir}/man1/tvheadend.1
	rm -rf ${DESTDIR}${datadir}/tvheadend
