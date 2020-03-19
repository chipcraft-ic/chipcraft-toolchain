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
LOCALROOT = $(abs_top_builddir)/localroot
# directory where finished toolchains will be installed
OUTPUTROOT = $(abs_top_builddir)/outputroot

# handle changes in configure.ac
$(abs_top_srcdir)/configure: $(abs_top_srcdir)/configure.ac $(abs_top_srcdir)/aclocal.m4
	$(CD) '$(abs_top_srcdir)' \
	&& autoconf -I m4 \
	$(EOL)

if CT_NG_ALREADY_BUILT
# when installing we force prefix because
# we have been given an already configured and built ct-ng sources
$(LOCALROOT)/bin/ct-ng: $(CT_NG_SRCDIR)/Makefile $(CT_NG_SRCDIR)/ct-ng
	$(MKDIR_P) $(LOCALROOT)
	$(MAKE) -C '$(CT_NG_SRCDIR)' \
	  prefix=$(LOCALROOT) \
	  install \
	  $(EOF)
else !CT_NG_ALREADY_BUILT
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
	  --prefix $(LOCALROOT) \
	$(EOL)

# when installing we force prefix because
# we may have been given an already configured ct-ng sources
$(LOCALROOT)/bin/ct-ng: $(LOCALROOT)/build/ct-ng/Makefile
	$(IS_DIR) '$(LOCALROOT)/build/ct-ng'
	$(MAKE) -C '$(LOCALROOT)/build/ct-ng'
	$(MAKE) -C '$(LOCALROOT)/build/ct-ng' \
	  prefix=$(LOCALROOT) \
	  install \
	  $(EOF)
endif !CT_NG_ALREADY_BUILT

LIBC_SO_PATH = $(shell \
  find /usr/ -path "*/libc.so" -printf "%h" -quit  2>/dev/null \
)
LIBM_A_PATH = $(shell \
  find /usr/ -path "*$(LINUX_TRIPLET)*/libm.a" -printf "%h" -quit 2>/dev/null \
)

$(LOCALROOT)/toolchain/mips/%/.config: $(abs_top_srcdir)/resources/configs/mips-%.in
	$(MKDIR_P) $(dir $@)
	$(SED) \
	  " \
	    s|@OUTPUTROOT@|$(OUTPUTROOT)|; \
	    s|@MAKE_JOBS@|$(shell nproc)|; \
	    s|@EXTRA_LDFLAGS_FOR_BUILD@|-L$(LIBC_SO_PATH) -L$(LIBM_A_PATH)|; \
	    s|@EXTRA_LDFLAGS_FOR_HOST@|-L$(LIBC_SO_PATH) -L$(LIBM_A_PATH)|; \
	    s|@BUILD_TRIPLET@|$(LINUX_TRIPLET)|; \
	    s|@HOST_TRIPLET@|$(LINUX_TRIPLET)|; \
	    s|@BINUTILS_URL@|$(MIPS_BINUTILS_GDB_SRCDIR)|; \
	    s|@NEWLIB_URL@|$(MIPS_NEWLIB_SRCDIR)|; \
	    s|@GCC_URL@|$(MIPS_GCC_SRCDIR)|; \
	    s|@GDB_URL@|$(MIPS_BINUTILS_GDB_SRCDIR)|; \
	  " \
	$< > $@ \
	$(EOL)

if LINUX_TOOLCHAIN
$(OUTPUTROOT)/$(LINUX_TRIPLET): $(LOCALROOT)/toolchain/mips/linux/.config $(LOCALROOT)/bin/ct-ng
	$(CD) $(dir $(word 1,$^)) \
	&& $(word 2,$^) build \
	$(EOL)

LINUX_DEPENDENCY = $(OUTPUTROOT)/$(LINUX_TRIPLET)
else !LINUX_TOOLCHAIN
LINUX_DEPENDENCY =
endif !LINUX_TOOLCHAIN

if WINDOWS_TOOLCHAIN
$(OUTPUTROOT)/$(WINDOWS_TRIPLET): $(LOCALROOT)/toolchain/mips/windows/.config $(LOCALROOT)/bin/ct-ng
	$(CD) $(dir $(word 1,$^)) \
	&& $(word 2,$^) build \
	$(EOL)

WINDOWS_DEPENDENCY = $(OUTPUTROOT)/$(WINDOWS_TRIPLET)
else !WINDOWS_TOOLCHAIN
WINDOWS_DEPENDENCY =
endif !WINDOWS_TOOLCHAIN

all: $(LINUX_DEPENDENCY) $(WINDOWS_DEPENDENCY)

