VPATH += $(abs_top_builddir)

# end of line for ease of use in multiline definitions
EOL :=
COMMA :=,
SLASH :=/

CAT := cat
CD := cd
CP_R := cp -r
ECHO := echo -n
MAKE := make
RM_RF := rm -rf
TOUCH := touch

EXTRA_DIST = \
  bootstrap \
  LICENSE \
  m4 \
  resources \
  $(EOL)

# directory where all the building shall be done
WORKDIR := $(abs_top_builddir)/workdir
# directory where 3rd party tools used for
# building the toolchains shall be installed
LOCALROOT := $(abs_top_builddir)/localroot
# directory where bootstrap toolchain will be installed
BOOTSTRAPROOT := $(abs_top_builddir)/bootstraproot
# directory where finished bare metal toolchains will be installed
OUTPUTROOT := $(abs_top_builddir)/outputroot

# installer(package, srcdir, prerequisites, build_check_file, configure_flags)
define installer
$$(WORKDIR)/$$(notdir $$(basename $1))/Makefile: \
  $2/configure \
  $3 \
  $$(EOL)
	$$(MKDIR_P) '$$(@D)'
	$$(CD) '$$(@D)' \
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
	$$(MAKE) -C '$$(<D)' \
	$$(EOL)

$$(LOCALROOT)/$1: \
  PATH := $$(LOCALROOT)/bin:/usr/bin:$$(PATH) \
  $(EOL)

$$(LOCALROOT)/$1: \
  $$(WORKDIR)/$$(notdir $$(basename $1))/$4 \
  $$(EOL)
	$$(MAKE) -C '$$(WORKDIR)/$$(notdir $$(basename $1))' \
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
  s|!CT_RISCV_BINUTILS_URL!|$(CHIPCRAFT_TOOLCHAIN_RISCV_BINUTILS_GDB_SRCDIR)|; \
  s|!CT_RISCV_GCC_URL!|$(CHIPCRAFT_TOOLCHAIN_RISCV_GCC_SRCDIR)|; \
  s|!CT_RISCV_NEWLIB_URL!|$(CHIPCRAFT_TOOLCHAIN_RISCV_NEWLIB_SRCDIR)|; \
  s|!CT_RISCV_GDB_URL!|$(CHIPCRAFT_TOOLCHAIN_RISCV_BINUTILS_GDB_SRCDIR)|; \
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
	    $(SED_SRCDIR_SUBSTITUTIONS) \
	  " \
	$< > $@ \
	$(EOL)

BOOTSTRAP := $(BOOTSTRAPROOT)/.done

$(BOOTSTRAP): \
  $(WORKDIR)/toolchain/host/.config \
  $(PREREQUISITES) \
  $(EOL)
	$(CD) $(dir $(word 1,$^)) \
	&& $(LOCALROOT)/bin/ct-ng build \
	&& $(TOUCH) $@ \
	$(EOL)

# will be filled by platform-specific rules
CT_EXTRA_CFLAGS_FOR_BUILD =

CT_EXTRA_LDFLAGS_FOR_BUILD = \
  -Wl,-rpath \
  -Wl,$(BOOTSTRAPROOT)/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)/sysroot/lib \
  -Wl,-rpath \
  -Wl,$(BOOTSTRAPROOT)/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)/sysroot/$(CHIPCRAFT_TOOLCHAIN_LIBDIR) \
  -Wl,-rpath \
  -Wl,$(BOOTSTRAPROOT)/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)/sysroot/usr/lib \
  -Wl,-rpath \
  -Wl,$(BOOTSTRAPROOT)/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)/sysroot/usr/$(CHIPCRAFT_TOOLCHAIN_LIBDIR) \
  -Wl,--dynamic-linker=$(BOOTSTRAPROOT)/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)/sysroot/$(CHIPCRAFT_TOOLCHAIN_LIBDIR)/ld-chipcraft.so
  $(EOL)

CT_EXTRA_LDFLAGS_FOR_HOST =

# Disable all extended instructions.
# We want the binaries to work
# on widest possible range of x86_64 cpus.
# Note: MMX and SSE are explicitly allowed
CHIPCRAFT_GENERALIZE_BINARIES := \
	-march=x86-64 \
	-mtune=generic \
	-mmmx \
	-msse \
	-mno-sse2 \
	-mno-sse3 \
	-mno-ssse3 \
	-mno-sse4 \
	-mno-sse4a \
	-mno-sse4.1 \
	-mno-sse4.2 \
	-mno-avx \
	-mno-avx2 \
	-mno-3dnow \
	-mno-abm \
	-mno-adx \
	-mno-aes \
	-mno-bmi \
	-mno-bmi2 \
	-mno-f16c \
	-mno-fma \
	-mno-fma4 \
	-mno-fsgsbase \
	-mno-fxsr \
	-mno-hle \
	-mno-lwp \
	-mno-lzcnt \
	-mno-movbe \
	-mno-pclmul \
	-mno-popcnt \
	-mno-prefetchwt1 \
	-mno-prfchw \
	-mno-rdrnd \
	-mno-rdseed \
	-mno-rtm \
	-mno-sha \
	-mno-tbm \
	-mno-xop \
	-mno-xsave \
	-mno-xsaveopt \
	$(EOL)

if CHIPCRAFT_TOOLCHAIN_LINUX
LINUX_DEPENDENCY = linux-dependent
LINUX_INSTALL_DEPENDENCY = linux-dependent
LINUX_UNINSTALL_DEPENDENCY =
LINUX_PACK_DEPENDENCY = linux-dependent
else !CHIPCRAFT_TOOLCHAIN_LINUX
LINUX_DEPENDENCY =
LINUX_INSTALL_DEPENDENCY =
LINUX_UNINSTALL_DEPENDENCY =
LINUX_PACK_DEPENDENCY =
endif !CHIPCRAFT_TOOLCHAIN_LINUX

if CHIPCRAFT_TOOLCHAIN_WINDOWS
WINDOWS_DEPENDENCY = windows-dependent
WINDOWS_INSTALL_DEPENDENCY = windows-dependent
WINDOWS_UNINSTALL_DEPENDENCY =
WINDOWS_PACK_DEPENDENCY = windows-dependent
else !CHIPCRAFT_TOOLCHAIN_WINDOWS
WINDOWS_DEPENDENCY =
WINDOWS_INSTALL_DEPENDENCY =
WINDOWS_UNINSTALL_DEPENDENCY =
WINDOWS_PACK_DEPENDENCY =
endif !CHIPCRAFT_TOOLCHAIN_WINDOWS

# one variable assignment per rule!

$(WORKDIR)/toolchain/%/linux/.config: \
  CT_HOST_TRIPLET = $(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)

$(WORKDIR)/toolchain/%/windows/.config: \
  CT_HOST_TRIPLET = $(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET)

.checks/template-checker-%/linux-rule: \
  $(abs_top_srcdir)/resources/configs/%.in \
  $(EOL)
	$(MKDIR_P) $(@D)
	$(ECHO) $< > $@

.checks/template-checker-%/windows-rule: \
  $(abs_top_srcdir)/resources/configs/%.in \
  $(EOL)
	$(MKDIR_P) $(@D)
	$(ECHO) $< > $@

$(WORKDIR)/toolchain/%/.config: \
  .checks/template-checker-%-rule \
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
	    s|!CT_GENERALIZE_BINARIES!|$(CHIPCRAFT_GENERALIZE_BINARIES)|; \
	    $(SED_SRCDIR_SUBSTITUTIONS) \
	  " \
	$(shell $(CAT) $<) > $@ \
	$(EOL)

$(OUTPUTROOT)/%/.done: \
  PATH := $(BOOTSTRAPROOT)/bin:$(LOCALROOT)/bin:/usr/bin:$(PATH) \
  $(EOL)

.checks/build-checker-$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)/%-rule: \
  $(WORKDIR)/toolchain/%/linux/.config \
  $(EOL)
	$(MKDIR_P) $(@D)
	$(ECHO) $(<D) > $@

.checks/build-checker-$(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET)/%-rule: \
  $(WORKDIR)/toolchain/%/windows/.config \
  $(EOL)
	$(MKDIR_P) $(@D)
	$(ECHO) $(<D) > $@

$(OUTPUTROOT)/%/.done: \
  .checks/build-checker-%-rule \
  $(PREREQUISITES) \
  $(BOOTSTRAP) \
  $(EOL)
	$(CD) $(shell $(CAT) $<) \
	&& $(LOCALROOT)/bin/ct-ng build \
	&& $(TOUCH) $@ \
	$(EOL)

.checks/install-checker-%-cc-elf/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)-rule: \
  $(OUTPUTROOT)/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)/%/.done \
  $(EOL)
	$(MKDIR_P) $(@D)
	$(ECHO) $(<D) > $@

.checks/install-checker-%-cc-elf/$(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET)-rule: \
  $(OUTPUTROOT)/$(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET)/%/.done \
  $(EOL)
	$(MKDIR_P) $(@D)
	$(ECHO) $(<D) > $@

$(DESTDIR)/$(prefix)/%/.done: \
  .checks/install-checker-%-rule \
  $(EOL)
	$(MKDIR_P) $(@D)
	$(CP_R) $(shell $(CAT) $<)/* $(@D)
	$(RM_RF) $(@D)/build.log
	$(TOUCH) $@

$(DESTDIR)/$(prefix)/mips-cc-elf/%/bin/chipcraft-toolchain-triplet:
	$(MKDIR_P) $(@D)
	$(ECHO) "mips-cc-elf" > $@

$(DESTDIR)/$(prefix)/riscv-cc-elf/%/bin/chipcraft-toolchain-triplet:
	$(MKDIR_P) $(@D)
	$(ECHO) "riscv-cc-elf" > $@

.checks/pack-checker-$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)-%-rule: \
  $(OUTPUTROOT)/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)/%/.done \
  $(EOL)
	$(MKDIR_P) $(@D)
	$(ECHO) $(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)/$* > $@

.checks/pack-checker-$(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET)-%-rule: \
  $(OUTPUTROOT)/$(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET)/%/.done \
  $(EOL)
	$(MKDIR_P) $(@D)
	$(ECHO) $(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET)/$* > $@

%.tar.gz: \
  .checks/pack-checker-%-rule \
  $(EOL)
	$(TAR) \
	  --directory=$(OUTPUTROOT) \
	  --create \
	  --file=$@ \
	  --format=posix \
	  --gzip \
	  $(shell $(CAT) $<)

if CHIPCRAFT_TOOLCHAIN_LINUX

linux-dependent:

if CHIPCRAFT_TOOLCHAIN_ARCH_MIPS
LINUX_DEPENDENCY += \
  $(OUTPUTROOT)/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)/mips/.done \
  $(EOL)

LINUX_INSTALL_DEPENDENCY += \
  $(DESTDIR)/$(prefix)/mips-cc-elf/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)/.done \
  $(DESTDIR)/$(prefix)/mips-cc-elf/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)/bin/chipcraft-toolchain-triplet \
  $(EOL)

LINUX_UNINSTALL_DEPENDENCY += \
  $(DESTDIR)/$(prefix)/mips-cc-elf/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET) \
  $(EOL)

LINUX_PACK_DEPENDENCY += \
  $(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)-mips.tar.gz \
  $(EOL)
endif CHIPCRAFT_TOOLCHAIN_ARCH_MIPS

if CHIPCRAFT_TOOLCHAIN_ARCH_RISCV
LINUX_DEPENDENCY += \
  $(OUTPUTROOT)/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)/riscv/.done \
  $(EOL)

LINUX_INSTALL_DEPENDENCY += \
  $(DESTDIR)/$(prefix)/riscv-cc-elf/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)/.done \
  $(DESTDIR)/$(prefix)/riscv-cc-elf/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)/bin/chipcraft-toolchain-triplet \
  $(EOL)

LINUX_UNINSTALL_DEPENDENCY += \
  $(DESTDIR)/$(prefix)/riscv-cc-elf/$(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET) \
  $(EOL)

LINUX_PACK_DEPENDENCY += \
  $(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET)-riscv.tar.gz \
  $(EOL)
endif CHIPCRAFT_TOOLCHAIN_ARCH_RISCV

pack-linux: \
  $(LINUX_PACK_DEPENDENCY) \
  $(EOL)

install-data-local-linux: \
  $(LINUX_INSTALL_DEPENDENCY) \
  $(EOL)

uninstall-local-linux:
	$(RM_RF) $(LINUX_UNINSTALL_DEPENDENCY)

else !CHIPCRAFT_TOOLCHAIN_LINUX
pack-linux:

install-data-local-linux:

uninstall-local-linux:

endif !CHIPCRAFT_TOOLCHAIN_LINUX

if CHIPCRAFT_TOOLCHAIN_WINDOWS

windows-dependent:

if CHIPCRAFT_TOOLCHAIN_ARCH_MIPS
WINDOWS_DEPENDENCY += \
  $(OUTPUTROOT)/$(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET)/mips/.done \
  $(EOL)

WINDOWS_INSTALL_DEPENDENCY += \
  $(DESTDIR)/$(prefix)/mips-cc-elf/$(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET)/.done \
  $(DESTDIR)/$(prefix)/mips-cc-elf/$(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET)/bin/chipcraft-toolchain-triplet \
  $(EOL)

WINDOWS_UNINSTALL_DEPENDENCY += \
  $(DESTDIR)/$(prefix)/mips-cc-elf/$(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET) \
  $(EOL)

WINDOWS_PACK_DEPENDENCY += \
  $(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET)-mips.tar.gz \
  $(EOL)
endif CHIPCRAFT_TOOLCHAIN_ARCH_MIPS

if CHIPCRAFT_TOOLCHAIN_ARCH_RISCV
WINDOWS_DEPENDENCY += \
  $(OUTPUTROOT)/$(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET)/riscv/.done \
  $(EOL)

WINDOWS_INSTALL_DEPENDENCY += \
  $(DESTDIR)/$(prefix)/riscv-cc-elf/$(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET)/.done \
  $(DESTDIR)/$(prefix)/riscv-cc-elf/$(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET)/bin/chipcraft-toolchain-triplet \
  $(EOL)

WINDOWS_UNINSTALL_DEPENDENCY += \
  $(DESTDIR)/$(prefix)/riscv-cc-elf/$(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET) \
  $(EOL)

WINDOWS_PACK_DEPENDENCY += \
  $(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET)-riscv.tar.gz \
  $(EOL)
endif CHIPCRAFT_TOOLCHAIN_ARCH_RISCV

pack-windows: \
  $(WINDOWS_PACK_DEPENDENCY) \
  $(EOL)

install-data-local-windows: \
  $(WINDOWS_INSTALL_DEPENDENCY) \
  $(EOL)

uninstall-local-windows:
	$(RM_RF) $(WINDOWS_UNINSTALL_DEPENDENCY)
	-$(RM_RF) .checks/install-checker

else !CHIPCRAFT_TOOLCHAIN_WINDOWS
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

clean-local-localroot:
	-$(RM_RF) \
	  $(LOCALROOT) \
	  $(EOL)

clean-local-bootstraproot:
	-$(RM_RF) \
	  $(BOOTSTRAPROOT) \
	  $(EOL)

clean-local-outputroot:
	-$(RM_RF) \
	  $(OUTPUTROOT) \
	  .checks/install-checker* \
	  $(EOL)

clean-local-workdir:
	-$(RM_RF) \
	  $(WORKDIR) \
	  .checks/build-checker* \
	  $(EOL)

clean-local: \
  clean-local-localroot \
  clean-local-bootstraproot \
  clean-local-outputroot \
  clean-local-workdir \
  $(EOL)
	-$(RM_RF) \
	  .checks \
	  $(CHIPCRAFT_TOOLCHAIN_BOOTSTRAP_TRIPLET).tar.gz \
	  $(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET).tar.gz \
	  $(EOL)

debug-print-%:
	@echo $* = $($*)

