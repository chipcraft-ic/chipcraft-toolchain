VPATH += $(abs_top_builddir)

EOL =
COMMA =,

CD = cd
CP_R = cp -r
# end of line for ease of use in multiline definitions
EOL =
MAKE = make
RM_RF = rm -rf

EXTRA_DIST = \
  bootstrap \
  LICENSE \
  m4 \
  resources \
  $(EOL)

# directory where all the building shall be done
WORKDIR = $(abs_top_builddir)/workdir
# directory where 3rd party tools used for
# building the toolchains shall be installed
LOCALROOT = $(abs_top_builddir)/localroot
# directory where bootstrap toolchain will be installed
BOOTSTRAPROOT = $(abs_top_builddir)/bootstraproot
# directory where finished bare metal toolchains will be installed
OUTPUTROOT = $(abs_top_builddir)/outputroot

# installer(package, srcdir, prerequisites, build_check_file, configure_flags)
define installer
$$(WORKDIR)/$$(notdir $$(basename $1))/Makefile: \
  $2/configure \
  $3 \
  $$(EOL)
	$$(MKDIR_P) '$$(WORKDIR)/$$(notdir $$(basename $1))'
	$$(CD) '$$(WORKDIR)/$$(notdir $$(basename $1))' \
	&& \
	  CPPFLAGS="-I$$(LOCALROOT)/include -I$$(LOCALROOT)/include/ncurses" \
	  LDFLAGS="-L$$(LOCALROOT)/lib" \
	  $$(word 1,$$^) \
	  --prefix $$(LOCALROOT) \
	  $5 \
	$$(EOL)

$$(WORKDIR)/$$(notdir $$(basename $1))/$4: \
  $$(WORKDIR)/$$(notdir $$(basename $1))/Makefile \
  $$(EOL)
	$$(MAKE) -C '$$(WORKDIR)/$$(notdir $$(basename $1))' \
	$$(EOL)

$$(LOCALROOT)/$1: \
  PATH := $$(LOCALROOT)/bin:/usr/bin:$$(PATH) \
  $(EOL)

$$(LOCALROOT)/$1: \
  $$(WORKDIR)/$$(notdir $$(basename $1))/$4 \
  $$(EOL)
	$$(MAKE) -C '$$(WORKDIR)/$$(notdir $$(basename $1))' \
	  prefix=$$(LOCALROOT) \
	  install \
	  $$(EOL)
endef

$(eval $(call installer,bin/m4,$(CHIPCRAFT_TOOLCHAIN_M4_SRCDIR),,src/m4,))
$(eval $(call installer,bin/autoconf,$(CHIPCRAFT_TOOLCHAIN_AUTOCONF_SRCDIR), \
  $(LOCALROOT)/bin/m4 \
,bin/autoconf,))
$(eval $(call installer,bin/automake,$(CHIPCRAFT_TOOLCHAIN_AUTOMAKE_SRCDIR), \
  $(LOCALROOT)/bin/m4 \
  $(LOCALROOT)/bin/autoconf \
,bin/automake,))
$(eval $(call installer,bin/libtool,$(CHIPCRAFT_TOOLCHAIN_LIBTOOL_SRCDIR), \
  $(LOCALROOT)/bin/m4 \
  $(LOCALROOT)/bin/autoconf \
  $(LOCALROOT)/bin/automake \
,libtool,))
$(eval $(call installer,bin/make,$(CHIPCRAFT_TOOLCHAIN_MAKE_SRCDIR), \
  $(LOCALROOT)/bin/m4 \
  $(LOCALROOT)/bin/autoconf \
  $(LOCALROOT)/bin/automake \
  $(LOCALROOT)/bin/libtool \
,make,))
$(eval $(call installer,lib/libz.a,$(CHIPCRAFT_TOOLCHAIN_ZLIB_SRCDIR), \
  $(LOCALROOT)/bin/m4 \
  $(LOCALROOT)/bin/autoconf \
  $(LOCALROOT)/bin/automake \
  $(LOCALROOT)/bin/libtool \
  $(LOCALROOT)/bin/make \
,libz.a,))
$(eval $(call installer,bin/git,$(CHIPCRAFT_TOOLCHAIN_GIT_SRCDIR), \
  $(LOCALROOT)/bin/m4 \
  $(LOCALROOT)/bin/autoconf \
  $(LOCALROOT)/bin/automake \
  $(LOCALROOT)/bin/libtool \
  $(LOCALROOT)/bin/make \
  $(LOCALROOT)/lib/libz.a \
,git,))
$(eval $(call installer,bin/gettext,$(CHIPCRAFT_TOOLCHAIN_GETTEXT_SRCDIR), \
  $(LOCALROOT)/bin/m4 \
  $(LOCALROOT)/bin/autoconf \
  $(LOCALROOT)/bin/automake \
  $(LOCALROOT)/bin/libtool \
  $(LOCALROOT)/bin/make \
  $(LOCALROOT)/lib/libz.a \
  $(LOCALROOT)/bin/libtool \
,gettext-runtime/src/gettext,))
$(eval $(call installer,bin/bison,$(CHIPCRAFT_TOOLCHAIN_BISON_SRCDIR), \
  $(LOCALROOT)/bin/m4 \
  $(LOCALROOT)/bin/autoconf \
  $(LOCALROOT)/bin/automake \
  $(LOCALROOT)/bin/libtool \
  $(LOCALROOT)/bin/make \
  $(LOCALROOT)/lib/libz.a \
  $(LOCALROOT)/bin/libtool \
  $(LOCALROOT)/bin/gettext \
,src/bison,))
$(eval $(call installer,bin/flex,$(CHIPCRAFT_TOOLCHAIN_FLEX_SRCDIR), \
  $(LOCALROOT)/bin/m4 \
  $(LOCALROOT)/bin/autoconf \
  $(LOCALROOT)/bin/automake \
  $(LOCALROOT)/bin/libtool \
  $(LOCALROOT)/bin/make \
  $(LOCALROOT)/lib/libz.a \
  $(LOCALROOT)/bin/libtool \
  $(LOCALROOT)/bin/gettext \
  $(LOCALROOT)/bin/bison \
,src/flex,))
$(eval $(call installer,bin/gawk,$(CHIPCRAFT_TOOLCHAIN_GAWK_SRCDIR), \
  $(LOCALROOT)/bin/m4 \
  $(LOCALROOT)/bin/autoconf \
  $(LOCALROOT)/bin/automake \
  $(LOCALROOT)/bin/libtool \
  $(LOCALROOT)/bin/make \
  $(LOCALROOT)/lib/libz.a \
  $(LOCALROOT)/bin/libtool \
  $(LOCALROOT)/bin/gettext \
  $(LOCALROOT)/bin/bison \
  $(LOCALROOT)/bin/flex \
,gawk,))
$(eval $(call installer,lib/libncurses.a,$(CHIPCRAFT_TOOLCHAIN_NCURSES_SRCDIR), \
  $(LOCALROOT)/bin/m4 \
  $(LOCALROOT)/bin/autoconf \
  $(LOCALROOT)/bin/automake \
  $(LOCALROOT)/bin/libtool \
  $(LOCALROOT)/bin/make \
  $(LOCALROOT)/lib/libz.a \
  $(LOCALROOT)/bin/libtool \
  $(LOCALROOT)/bin/gettext \
  $(LOCALROOT)/bin/bison \
  $(LOCALROOT)/bin/flex \
  $(LOCALROOT)/bin/gawk \
,lib/libncurses.a,--with-shared --without-debug))
$(eval $(call installer,bin/ct-ng,$(CHIPCRAFT_TOOLCHAIN_CT_NG_SRCDIR), \
  $(LOCALROOT)/bin/m4 \
  $(LOCALROOT)/bin/autoconf \
  $(LOCALROOT)/bin/automake \
  $(LOCALROOT)/bin/libtool \
  $(LOCALROOT)/bin/make \
  $(LOCALROOT)/lib/libz.a \
  $(LOCALROOT)/bin/libtool \
  $(LOCALROOT)/bin/gettext \
  $(LOCALROOT)/bin/bison \
  $(LOCALROOT)/bin/flex \
  $(LOCALROOT)/bin/gawk \
  $(LOCALROOT)/lib/libncurses.a \
,ct-ng,CURSES_LIBS="-L$(LOCALROOT)/lib -Wl$(COMMA)--rpath -Wl$(COMMA)$(LOCALROOT)/lib -lncurses" CURSES_CFLAGS="-I$(LOCALROOT)/include -I$(LOCALROOT)/include/ncurses"))

PREREQUISITES := \
  $(LOCALROOT)/bin/m4 \
  $(LOCALROOT)/bin/autoconf \
  $(LOCALROOT)/bin/automake \
  $(LOCALROOT)/bin/libtool \
  $(LOCALROOT)/bin/make \
  $(LOCALROOT)/bin/libtool \
  $(LOCALROOT)/bin/gettext \
  $(LOCALROOT)/bin/bison \
  $(LOCALROOT)/bin/flex \
  $(LOCALROOT)/bin/gawk \
  $(LOCALROOT)/bin/ct-ng \
  $(LOCALROOT)/lib/libz.a \
  $(LOCALROOT)/lib/libncurses.a \
  $(EOL)

CT_HOST_TRIPLET =

# keep in sync with configure.ac
SED_SRCDIR_SUBSTITUTIONS := \
  s|!CT_M4_URL!|$(CHIPCRAFT_TOOLCHAIN_M4_SRCDIR)|; \
  s|!CT_AUTOCONF_URL!|$(CHIPCRAFT_TOOLCHAIN_AUTOCONF_SRCDIR)|; \
  s|!CT_AUTOMAKE_URL!|$(CHIPCRAFT_TOOLCHAIN_AUTOMAKE_SRCDIR)|; \
  s|!CT_LIBTOOL_URL!|$(CHIPCRAFT_TOOLCHAIN_LIBTOOL_SRCDIR)|; \
  s|!CT_MAKE_URL!|$(CHIPCRAFT_TOOLCHAIN_MAKE_SRCDIR)|; \
  s|!CT_BINUTILS_URL!|$(CHIPCRAFT_TOOLCHAIN_BINUTILS_SRCDIR)|; \
  s|!CT_BISON_URL!|$(CHIPCRAFT_TOOLCHAIN_BISON_SRCDIR)|; \
  s|!CT_CLOOG_URL!|$(CHIPCRAFT_TOOLCHAIN_CLOOG_SRCDIR)|; \
  s|!CT_EXPAT_URL!|$(CHIPCRAFT_TOOLCHAIN_EXPAT_SRCDIR)|; \
  s|!CT_FLEX_URL!|$(CHIPCRAFT_TOOLCHAIN_FLEX_SRCDIR)|; \
  s|!CT_GAWK_URL!|$(CHIPCRAFT_TOOLCHAIN_GAWK_SRCDIR)|; \
  s|!CT_GCC_URL!|$(CHIPCRAFT_TOOLCHAIN_GCC_SRCDIR)|; \
  s|!CT_GETTEXT_URL!|$(CHIPCRAFT_TOOLCHAIN_GETTEXT_SRCDIR)|; \
  s|!CT_GLIBC_URL!|$(CHIPCRAFT_TOOLCHAIN_GLIBC_SRCDIR)|; \
  s|!CT_GMP_URL!|$(CHIPCRAFT_TOOLCHAIN_GMP_SRCDIR)|; \
  s|!CT_ISL_URL!|$(CHIPCRAFT_TOOLCHAIN_ISL_SRCDIR)|; \
  s|!CT_LIBICONV_URL!|$(CHIPCRAFT_TOOLCHAIN_LIBICONV_SRCDIR)|; \
  s|!CT_MPC_URL!|$(CHIPCRAFT_TOOLCHAIN_MPC_SRCDIR)|; \
  s|!CT_MPFR_URL!|$(CHIPCRAFT_TOOLCHAIN_MPFR_SRCDIR)|; \
  s|!CT_NCURSES_URL!|$(CHIPCRAFT_TOOLCHAIN_NCURSES_SRCDIR)|; \
  s|!CT_ZLIB_URL!|$(CHIPCRAFT_TOOLCHAIN_ZLIB_SRCDIR)|; \
  s|!CT_MIPS_BINUTILS_URL!|$(CHIPCRAFT_TOOLCHAIN_MIPS_BINUTILS_GDB_SRCDIR)|; \
  s|!CT_MIPS_GCC_URL!|$(CHIPCRAFT_TOOLCHAIN_MIPS_GCC_SRCDIR)|; \
  s|!CT_MIPS_NEWLIB_URL!|$(CHIPCRAFT_TOOLCHAIN_MIPS_NEWLIB_SRCDIR)|; \
  s|!CT_MIPS_GDB_URL!|$(CHIPCRAFT_TOOLCHAIN_MIPS_BINUTILS_GDB_SRCDIR)|; \
  s|!CT_LINUX_URL!|$(CHIPCRAFT_TOOLCHAIN_LINUX_SRCDIR)|; \
  $(EOL)

$(WORKDIR)/toolchain/host/.config: \
  $(abs_top_srcdir)/resources/configs/host.in \
  $(EOL)
	$(MKDIR_P) '$(@D)'
	$(SED) \
	  " \
	    s|!CT_LOCALROOT!|$(LOCALROOT)|; \
	    s|!CT_OUTPUT_DIR!|$(BOOTSTRAPROOT)|; \
	    s|!CT_JOBS!|$(CHIPCRAFT_TOOLCHAIN_CPUS)|; \
	    s|!CT_BUILD_TRIPLET!|$(CHIPCRAFT_TOOLCHAIN_LINUX_TRIPLET)|; \
	    s|!CT_HOST_TRIPLET!|$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)|; \
	    s|!CT_BITNESS!|$(CHIPCRAFT_TOOLCHAIN_BITNESS)|; \
	    s|!CT_KERNEL_VERSION!|$(CHIPCRAFT_TOOLCHAIN_KERNEL)|; \
	    s|!CT_KERNEL_MAJOR!|$(CHIPCRAFT_TOOLCHAIN_KERNEL_MAJOR)|; \
	    s|!CT_KERNEL_MINOR!|$(CHIPCRAFT_TOOLCHAIN_KERNEL_MINOR)|; \
	    $(SED_SRCDIR_SUBSTITUTIONS) \
	  " \
	$(word 1,$^) > $@ \
	$(EOL)

BOOTSTRAP := \
  $(BOOTSTRAPROOT)/bin/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)-ar \
  $(BOOTSTRAPROOT)/bin/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)-as \
  $(BOOTSTRAPROOT)/bin/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)-g++ \
  $(BOOTSTRAPROOT)/bin/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)-gcc \
  $(BOOTSTRAPROOT)/bin/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)-ld \
  $(BOOTSTRAPROOT)/bin/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)-nm \
  $(BOOTSTRAPROOT)/bin/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)-objcopy \
  $(BOOTSTRAPROOT)/bin/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)-objdump \
  $(BOOTSTRAPROOT)/bin/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)-ranlib \
  $(BOOTSTRAPROOT)/bin/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)-readelf \
  $(BOOTSTRAPROOT)/bin/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)-strings \
  $(BOOTSTRAPROOT)/bin/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)-strip \
  $(EOL)

$(BOOTSTRAP): \
  $(WORKDIR)/toolchain/host/.config \
  $(PREREQUISITES) \
  $(EOL)
	$(CD) $(dir $(word 1,$^)) \
	&& $(LOCALROOT)/bin/ct-ng build \
	$(EOL)

# will be filled by platform-specific rules
CT_EXTRA_CFLAGS_FOR_BUILD =
CT_EXTRA_LDFLAGS_FOR_BUILD = \
  -Wl,--rpath \
  -Wl,$(BOOTSTRAPROOT)/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)/sysroot/$(CHIPCRAFT_TOOLCHAIN_LIBDIR) \
  -Wl,--rpath \
  -Wl,$(BOOTSTRAPROOT)/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)/sysroot/usr/$(CHIPCRAFT_TOOLCHAIN_LIBDIR) \
  -Wl,--dynamic-linker=$(BOOTSTRAPROOT)/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)/sysroot/$(CHIPCRAFT_TOOLCHAIN_LIBDIR)/ld-2.23.so
  $(EOL)

CT_EXTRA_LDFLAGS_FOR_HOST =

$(WORKDIR)/toolchain/mips/%/.config: \
  $(abs_top_srcdir)/resources/configs/mips.in \
  $(EOL)
	$(MKDIR_P) '$(@D)'
	$(SED) \
	  " \
	    s|!CT_OUTPUT_DIR!|$(OUTPUTROOT)/$(CT_HOST_TRIPLET)|; \
	    s|!CT_JOBS!|$(CHIPCRAFT_TOOLCHAIN_CPUS)|; \
	    s|!CT_BUILD_TRIPLET!|$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)|; \
	    s|!CT_HOST_TRIPLET!|$(CT_HOST_TRIPLET)|; \
	    s|!CT_EXTRA_CFLAGS_FOR_BUILD!|$(CT_EXTRA_CFLAGS_FOR_BUILD)|; \
	    s|!CT_EXTRA_LDFLAGS_FOR_BUILD!|$(CT_EXTRA_LDFLAGS_FOR_BUILD)|; \
	    s|!CT_EXTRA_LDFLAGS_FOR_HOST!|$(CT_EXTRA_LDFLAGS_FOR_HOST)|; \
	    $(SED_SRCDIR_SUBSTITUTIONS) \
	  " \
	$(word 1,$^) > $@ \
	$(EOL)

if CHIPCRAFT_TOOLCHAIN_LINUX
# one variable assignment per rule!
$(WORKDIR)/toolchain/mips/linux/.config: \
  CT_HOST_TRIPLET = $(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)
$(WORKDIR)/toolchain/mips/linux/.config: \
  CT_EXTRA_LDFLAGS_FOR_HOST = \
    -Wl,--whole-archive -lrt -lpthread -Wl,--no-whole-archive \
    $(EOL)

$(OUTPUTROOT)/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)/bin/mips-cc-elf-gcc: \
  PATH := $(BOOTSTRAPROOT)/bin:$(LOCALROOT)/bin:/usr/bin:$(PATH)
$(OUTPUTROOT)/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)/bin/mips-cc-elf-gcc: \
  $(WORKDIR)/toolchain/mips/linux/.config \
  $(PREREQUISITES) \
  $(BOOTSTRAP) \
  $(EOL)
	$(CD) $(dir $(word 1,$^)) \
	&& $(LOCALROOT)/bin/ct-ng build \
	$(EOL)

LINUX_DEPENDENCY := \
  $(OUTPUTROOT)/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)/bin/mips-cc-elf-gcc \
  $(EOL)

$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET).tar.gz: $(LINUX_DEPENDENCY)
	$(TAR) \
	  --directory=$(OUTPUTROOT) \
	  --create \
	  --file=$@ \
	  --format=posix \
	  --gzip \
	  $(@:%.tar.gz=%)

pack-linux: $(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET).tar.gz

$(DESTDIR)/$(prefix)/mips-cc-elf/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET): \
  $(LINUX_DEPENDENCY)
	$(MKDIR_P) $(DESTDIR)/$(prefix)/mips-cc-elf
	$(CP_R) \
	  $(OUTPUTROOT)/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET) \
	  $(DESTDIR)/$(prefix)/mips-cc-elf/

install-data-local-linux: \
  $(DESTDIR)/$(prefix)/mips-cc-elf/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)

uninstall-local-linux:
	$(RM_RF) \
	  $(DESTDIR)/$(prefix)/mips-cc-elf/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)

else !CHIPCRAFT_TOOLCHAIN_LINUX
LINUX_DEPENDENCY =

pack-linux:

install-data-local-linux:

uninstall-local-linux:

endif !CHIPCRAFT_TOOLCHAIN_LINUX

if CHIPCRAFT_TOOLCHAIN_WINDOWS
$(WORKDIR)/toolchain/mips/windows/.config: \
  CT_HOST_TRIPLET = $(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET)

$(OUTPUTROOT)/$(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET)/bin/mips-cc-elf-gcc.exe: \
  PATH := $(BOOTSTRAPROOT)/bin:$(LOCALROOT)/bin:/usr/bin:$(PATH)
$(OUTPUTROOT)/$(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET)/bin/mips-cc-elf-gcc.exe: \
  $(WORKDIR)/toolchain/mips/windows/.config \
  $(PREREQUISITES) \
  $(BOOTSTRAP) \
  $(EOL)
	$(CD) $(dir $(word 1,$^)) \
	&& $(LOCALROOT)/bin/ct-ng build \
	$(EOL)

WINDOWS_DEPENDENCY := \
  $(OUTPUTROOT)/$(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET)/bin/mips-cc-elf-gcc.exe \
  $(EOL)

$(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET).tar.gz: $(LINUX_DEPENDENCY)
	$(TAR) \
	  --directory=$(OUTPUTROOT) \
	  --create \
	  --file=$@ \
	  --format=posix \
	  --gzip \
	  $(@:%.tar.gz=%)

pack-windows: $(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET).tar.gz

$(DESTDIR)/$(prefix)/mips-cc-elf/$(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET): \
  $(WINDOWS_DEPENDENCY)
	$(MKDIR_P) $(DESTDIR)/$(prefix)/mips-cc-elf
	$(CP_R) \
	  $(OUTPUTROOT)/$(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET) \
	  $(DESTDIR)/$(prefix)/mips-cc-elf/

install-data-local-windows: \
  $(DESTDIR)/$(prefix)/mips-cc-elf/$(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET)

uninstall-local-windows:
	$(RM_RF) $(DESTDIR)/$(prefix)/mips-cc-elf/$(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET)

else !CHIPCRAFT_TOOLCHAIN_WINDOWS
WINDOWS_DEPENDENCY =

pack-windows:

install-data-local-windows:

uninstall-local-windows:

endif !CHIPCRAFT_TOOLCHAIN_WINDOWS

noinst_PROGRAMS := $(PREREQUISITE_PROGRAMS) $(BOOTSTRAP_PROGRAMS)
noinst_LIBRARIES := $(PREREQUISITE_LIBRARIES)

host: $(BOOTSTRAP_PROGRAMS)

linux: $(LINUX_DEPENDENCY)

windows: $(WINDOWS_DEPENDENCY)

all: linux windows

pack: pack-linux pack-windows

help:
	@echo "The following targets are available:"
	@echo "  linux - build Linux toolchain"
	@echo "  windows - build 32-bit Windows toolchain"
	@echo "  host - build bootstrap environment used for toolchain building"
	@echo "  install - install toolchains under prefix set during configuration phase"
	@echo "  	   e.g.: $(prefix)/mips-cc-elf/$(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET)"
	@echo "  pack - create *.tar.gz archives with built toolchains"
	@echo "  clean - remove all files created during build"
	@echo "  help - this help"
	@echo ""
	@echo "By default, the 'linux' and 'windows' targets are built."

install-data-local: install-data-local-linux install-data-local-windows

uninstall-local: uninstall-local-linux uninstall-local-windows

clean-local:
	-$(RM_RF) \
	  $(BOOTSTRAPROOT) \
	  $(LOCALROOT) \
	  $(OUTPUTROOT) \
	  $(WORKDIR) \
	  $(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET).tar.gz \
	  $(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET).tar.gz \
	  $(EOL)

