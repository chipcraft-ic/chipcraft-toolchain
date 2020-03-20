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
$(abs_top_srcdir)/configure: \
  $(abs_top_srcdir)/configure.ac \
  $(abs_top_srcdir)/aclocal.m4 \
  $(EOL)
	$(CD) '$(abs_top_srcdir)' \
	&& autoconf -I m4 \
	$(EOL)

if CT_NG_ALREADY_BUILT
# when installing we force prefix because
# we have been given an already configured and built ct-ng sources
$(LOCALROOT)/bin/ct-ng: \
  $(CT_NG_SRCDIR)/Makefile \
  $(CT_NG_SRCDIR)/ct-ng \
  $(EOL)
	$(MKDIR_P) $(LOCALROOT)
	$(MAKE) -C '$(CT_NG_SRCDIR)' \
	  prefix=$(LOCALROOT) \
	  install \
	  $(EOL)
else !CT_NG_ALREADY_BUILT
# this requires $(CT_NG_SRCDIR) to be writable
# however default path points to builddir
# which should always be writable
$(CT_NG_SRCDIR)/configure: \
  $(CT_NG_SRCDIR)/bootstrap \
  $(EOL)
	$(IS_DIR) '$(CT_NG_SRCDIR)'
	$(CD) '$(CT_NG_SRCDIR)' \
	&& $(CT_NG_SRCDIR)/bootstrap \
	$(EOL)

$(LOCALROOT)/build/ct-ng/Makefile: \
  $(CT_NG_SRCDIR)/configure \
  $(EOL)
	$(MKDIR_P) $(dir $@)
	$(CD) '$(dir $@)' \
	&& $(CT_NG_SRCDIR)/configure \
	  --prefix $(LOCALROOT) \
	$(EOL)

# when installing we force prefix because
# we may have been given an already configured ct-ng sources
$(LOCALROOT)/bin/ct-ng: \
  $(LOCALROOT)/build/ct-ng/Makefile \
  $(EOL)
	$(IS_DIR) '$(LOCALROOT)/build/ct-ng'
	$(MAKE) -C '$(LOCALROOT)/build/ct-ng'
	$(MAKE) -C '$(LOCALROOT)/build/ct-ng' \
	  prefix=$(LOCALROOT) \
	  install \
	  $(EOL)
endif !CT_NG_ALREADY_BUILT

LIBC_SO_PATH = $(shell \
  find /usr/ -path "*/libc.so" -printf "%h" -quit  2>/dev/null \
)
LIBM_A_PATH = $(shell \
  find /usr/ -path "*$(LINUX_TRIPLET)*/libm.a" -printf "%h" -quit 2>/dev/null \
)
CT_TARBALLS_STORAGE = $(abs_top_builddir)/tarballs
CT_NG_EXTRA_LDFLAGS_FOR_BUILD = -L$(LIBC_SO_PATH) -L$(LIBM_A_PATH)
CT_NG_EXTRA_LDFLAGS_FOR_HOST =
CT_NG_HOST_TRIPLET =

$(CT_TARBALLS_STORAGE):
	$(MKDIR_P) $@

$(LOCALROOT)/toolchain/mips/%/.config: \
  $(abs_top_srcdir)/resources/configs/mips-%.in\
  $(CT_TARBALLS_STORAGE) \
  $(EOL)
	$(MKDIR_P) $(dir $@)
	$(SED) \
	  " \
	    s|@TARBALLS_STORAGE@|$(CT_TARBALLS_STORAGE)|; \
	    s|@OUTPUTROOT@|$(OUTPUTROOT)|; \
	    s|@MAKE_JOBS@|$(shell nproc)|; \
	    s|@EXTRA_LDFLAGS_FOR_BUILD@|$(CT_NG_EXTRA_LDFLAGS_FOR_BUILD)|; \
	    s|@EXTRA_LDFLAGS_FOR_HOST@|$(CT_NG_EXTRA_LDFLAGS_FOR_HOST)|; \
	    s|@BUILD_TRIPLET@|$(LINUX_TRIPLET)|; \
	    s|@HOST_TRIPLET@|$(CT_NG_HOST_TRIPLET)|; \
	    s|@BINUTILS_URL@|$(MIPS_BINUTILS_GDB_SRCDIR)|; \
	    s|@NEWLIB_URL@|$(MIPS_NEWLIB_SRCDIR)|; \
	    s|@GCC_URL@|$(MIPS_GCC_SRCDIR)|; \
	    s|@GDB_URL@|$(MIPS_BINUTILS_GDB_SRCDIR)|; \
	  " \
	$< > $@ \
	$(EOL)

if LINUX_TOOLCHAIN
# one variable assignment per rule!
$(LOCALROOT)/toolchain/mips/linux/.config: \
  CT_NG_EXTRA_LDFLAGS_FOR_HOST = $(CT_NG_EXTRA_LDFLAGS_FOR_BUILD)
$(LOCALROOT)/toolchain/mips/linux/.config: \
  CT_NG_HOST_TRIPLET = $(LINUX_TRIPLET)

$(OUTPUTROOT)/$(LINUX_TRIPLET): \
  $(LOCALROOT)/toolchain/mips/linux/.config \
  $(LOCALROOT)/bin/ct-ng \
  $(EOL)
	$(CD) $(dir $(word 1,$^)) \
	&& $(word 2,$^) build \
	$(EOL)

LINUX_DEPENDENCY = $(OUTPUTROOT)/$(LINUX_TRIPLET)
else !LINUX_TOOLCHAIN
LINUX_DEPENDENCY =
endif !LINUX_TOOLCHAIN

if WINDOWS_TOOLCHAIN
$(LOCALROOT)/toolchain/mips/windows/.config: \
  CT_NG_HOST_TRIPLET = $(WINDOWS_TRIPLET)

$(OUTPUTROOT)/$(WINDOWS_TRIPLET): \
  $(LOCALROOT)/toolchain/mips/windows/.config \
  $(LOCALROOT)/bin/ct-ng \
  $(EOL)
	$(CD) $(dir $(word 1,$^)) \
	&& $(word 2,$^) build \
	$(EOL)

WINDOWS_DEPENDENCY = $(OUTPUTROOT)/$(WINDOWS_TRIPLET)
else !WINDOWS_TOOLCHAIN
WINDOWS_DEPENDENCY =
endif !WINDOWS_TOOLCHAIN

linux: $(LINUX_DEPENDENCY)

windows: $(WINDOWS_DEPENDENCY)

all: linux windows

