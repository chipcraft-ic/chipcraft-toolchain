VPATH += $(abs_top_builddir)

CD = cd
IS_DIR = test -d
# end of line for ease of use in multiline definitions
EOL =
MAKE = make

EXTRA_DIST = \
  bootstrap \
  m4 \
  resources \
  $(EOL)

# directory where 3rd party tools used for
# building the toolchain shall be installed
LOCALROOT = localroot

$(abs_top_srcdir)/configure: configure.ac aclocal.m4
	$(CD) '$(abs_top_srcdir)' \
	&& autoconf -I m4 \
	$(EOL)

# this requires $(CT_NG_SRCDIR) to be writable
# however default path points to builddir
# which should always be writable
$(CT_NG_SRCDIR)/configure: $(CT_NG_SRCDIR)/bootstrap
	$(IS_DIR) '$(CT_NG_SRCDIR)'
	$(CD) '$(CT_NG_SRCDIR)' \
	&& $(CT_NG_SRCDIR)/bootstrap \
	$(EOL)

$(LOCALROOT)/build/ct-ng/Makefile: $(CT_NG_SRCDIR)/configure
	$(MKDIR_P) $(dir $@)
	$(CD) '$(dir $@)' \
	&& $(CT_NG_SRCDIR)/configure \
	  --prefix $(abs_top_builddir)/$(LOCALROOT) \
	$(EOL)

$(LOCALROOT)/bin/ct-ng: $(LOCALROOT)/build/ct-ng/Makefile
	$(IS_DIR) '$(LOCALROOT)/build/ct-ng'
	$(MAKE) -C '$(LOCALROOT)/build/ct-ng'
	$(MAKE) -C '$(LOCALROOT)/build/ct-ng' install

if LINUX_TOOLCHAIN
$(LOCALROOT)/toolchain/mips/linux/.config: $(abs_top_srcdir)/resources/configs/mips.in
	$(MKDIR_P) $(dir $@)
	$(SED) \
	  " \
	    s|@MAKE_JOBS@|$(shell nproc)|; \
	    s|@LIBC_SO_PATH@|$(shell \
	      find /usr/ -path "*/libc.so" -printf "%h" -quit \
		2>/dev/null \
	    )|; \
	    s|@LIBM_A_PATH@|$(shell \
	      find /usr/ -path "*$(LINUX_TRIPLET)*/libm.a" -printf "%h" -quit \
		2>/dev/null \
	    )|; \
	    s|@BUILD_TRIPLET@|$(LINUX_TRIPLET)|; \
	    s|@HOST_TRIPLET@|$(LINUX_TRIPLET)|; \
	    s|@BINUTILS_URL@|$(MIPS_BINUTILS_GDB_SRCDIR)|; \
	    s|@NEWLIB_URL@|$(MIPS_NEWLIB_SRCDIR)|; \
	    s|@GCC_URL@|$(MIPS_GCC_SRCDIR)|; \
	    s|@GDB_URL@|$(MIPS_BINUTILS_GDB_SRCDIR)|; \
	  " \
	$< > $@ \
	$(EOL)

LINUX_DEPENDENCY = $(LOCALROOT)/toolchain/linux/.config
else !LINUX_TOOLCHAIN
LINUX_DEPENDENCY =
endif !LINUX_TOOLCHAIN

if WINDOWS_TOOLCHAIN
$(LOCALROOT)/toolchain/mips/windows/.config: $(abs_top_srcdir)/resources/configs/mips.in
	$(MKDIR_P) $(dir $@)
	$(SED) \
	  " \
	    s|@MAKE_JOBS@|$(shell nproc)|; \
	    s|@LIBC_SO_PATH@|$(shell \
	      find /usr/ -path "*/libc.so" -printf "%h" -quit \
		2>/dev/null \
	    )|; \
	    s|@LIBM_A_PATH@|$(shell \
	      find /usr/ -path "*$(LINUX_TRIPLET)*/libm.a" -printf "%h" -quit \
		2>/dev/null \
	    )|; \
	    s|@BUILD_TRIPLET@|$(LINUX_TRIPLET)|; \
	    s|@HOST_TRIPLET@|$(WINDOWS_TRIPLET)|; \
	    s|@BINUTILS_URL@|$(MIPS_BINUTILS_GDB_SRCDIR)|; \
	    s|@NEWLIB_URL@|$(MIPS_NEWLIB_SRCDIR)|; \
	    s|@GCC_URL@|$(MIPS_GCC_SRCDIR)|; \
	    s|@GDB_URL@|$(MIPS_BINUTILS_GDB_SRCDIR)|; \
	  " \
	$< > $@ \
	$(EOL)

WINDOWS_DEPENDENCY = $(LOCALROOT)/toolchain/windows/.config
else !WINDOWS_TOOLCHAIN
WINDOWS_DEPENDENCY =
endif !WINDOWS_TOOLCHAIN


