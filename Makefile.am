VPATH += $(abs_top_builddir)

$(abs_top_srcdir)/configure: configure.ac aclocal.m4
	cd '$(abs_top_srcdir)' && autoconf

config.status: configure
	./config.status --recheck

