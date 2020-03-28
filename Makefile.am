VPATH += $(abs_top_builddir)

EOL =
COMMA =,

CD = cd
IS_DIR = test -d
# end of line for ease of use in multiline definitions
MAKE = make

EXTRA_DIST = \
  bootstrap \
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

BACKUP_PATH := $(PATH)
PATH := $(LOCALROOT)/bin:$(BACKUP_PATH)

# handle changes in configure.ac
$(abs_top_srcdir)/configure: \
  $(abs_top_srcdir)/configure.ac \
  $(abs_top_srcdir)/aclocal.m4 \
  $(EOL)
	$(CD) '$(abs_top_srcdir)' \
	&& autoconf -I m4 \
	$(EOL)

# installer(package, srcdir, prerequisites, build_check_file, configure_flags)
define installer
$$(WORKDIR)/$1/Makefile: \
  $2/configure \
  $3 \
  $$(EOL)
	$$(MKDIR_P) '$$(WORKDIR)/$1'
	$$(CD) '$$(WORKDIR)/$1' \
	&& $$(word 1,$$^) \
	  --prefix $$(LOCALROOT) \
	  $5 \
	$$(EOL)

$$(WORKDIR)/$1/$4: \
  $$(WORKDIR)/$1/Makefile \
  $$(EOL)
	$$(MAKE) -C '$$(WORKDIR)/$1' \
	CPPFLAGS+="-I$$(LOCALROOT)/include -I$$(LOCALROOT)/include/ncurses" \
	$$(EOL)

$$(LOCALROOT)/bin/$1: \
  $$(WORKDIR)/$1/$4 \
  $$(EOL)
	$$(MAKE) -C '$$(WORKDIR)/$1' \
	  prefix=$$(LOCALROOT) \
	  install \
	  $$(EOL)
endef

$(eval $(call installer,m4,$(CHIPCRAFT_TOOLCHAIN_M4_SRCDIR),,src/m4,))
$(eval $(call installer,autoconf,$(CHIPCRAFT_TOOLCHAIN_AUTOCONF_SRCDIR),$(LOCALROOT)/bin/m4,bin/autoconf,))
$(eval $(call installer,automake,$(CHIPCRAFT_TOOLCHAIN_AUTOMAKE_SRCDIR),$(LOCALROOT)/bin/m4 $(LOCALROOT)/bin/autoconf,bin/automake,))
$(eval $(call installer,libtool,$(CHIPCRAFT_TOOLCHAIN_LIBTOOL_SRCDIR),$(LOCALROOT)/bin/m4 $(LOCALROOT)/bin/autoconf $(LOCALROOT)/bin/automake,libtool,))
$(eval $(call installer,make,$(CHIPCRAFT_TOOLCHAIN_MAKE_SRCDIR),$(LOCALROOT)/bin/m4 $(LOCALROOT)/bin/autoconf $(LOCALROOT)/bin/automake $(LOCALROOT)/bin/libtool,make,))

AUTOTOOLS = \
  $(LOCALROOT)/bin/m4 \
  $(LOCALROOT)/bin/autoconf \
  $(LOCALROOT)/bin/automake \
  $(LOCALROOT)/bin/libtool \
  $(LOCALROOT)/bin/make \
  $(EOL)

$(eval $(call installer,gettext,$(CHIPCRAFT_TOOLCHAIN_GETTEXT_SRCDIR),$(AUTOTOOLS),gettext-runtime/src/gettext,))
$(eval $(call installer,bison,$(CHIPCRAFT_TOOLCHAIN_BISON_SRCDIR),$(AUTOTOOLS) $(LOCALROOT)/bin/gettext,src/bison,))
$(eval $(call installer,flex,$(CHIPCRAFT_TOOLCHAIN_FLEX_SRCDIR),$(AUTOTOOLS) $(LOCALROOT)/bin/gettext $(LOCALROOT)/bin/bison,src/flex,))
$(eval $(call installer,gawk,$(CHIPCRAFT_TOOLCHAIN_GAWK_SRCDIR),$(AUTOTOOLS) $(LOCALROOT)/bin/gettext $(LOCALROOT)/bin/bison $(LOCALROOT)/bin/flex,src/gawk,))

TEXTTOOLS = \
  $(LOCALROOT)/bin/gettext \
  $(LOCALROOT)/bin/bison \
  $(LOCALROOT)/bin/flex \
  $(LOCALROOT)/bin/gawk \
  $(EOL)

# install ncurses
$(WORKDIR)/ncurses/Makefile: \
  $(CHIPCRAFT_TOOLCHAIN_NCURSES_SRCDIR)/configure \
  $(AUTOTOOLS) \
  $(TEXTTOOLS) \
  $(EOL)
	$(MKDIR_P) '$(dir $@)'
	$(CD) '$(dir $@)' \
	&& $(word 1,$^) \
	  --prefix $(LOCALROOT) \
	  --with-shared \
	  --without-debug \
	$(EOL)

$(WORKDIR)/ncurses/lib/ncurses.so \
  $(WORKDIR)/ncurses/lib/ncurses.a: \
  $(WORKDIR)/ncurses/Makefile \
  $(EOL)
	$(MAKE) -C '$(dir $(word 1,$^))'

$(LOCALROOT)/lib/libncurses.so: \
  $(WORKDIR)/ncurses/lib/ncurses.so \
  $(WORKDIR)/ncurses/lib/ncurses.a \
  $(EOL)
	$(MAKE) -C '$(WORKDIR)/ncurses' \
	  prefix=$(LOCALROOT) \
	  install \
	  $(EOL)

$(eval $(call installer,ct-ng,$(CHIPCRAFT_TOOLCHAIN_CT_NG_SRCDIR),$(AUTOTOOLS) $(TEXTTOOLS) $(LOCALROOT)/lib/libncurses.so,ct-ng,CURSES_LIBS="-L$(LOCALROOT)/lib -Wl$(COMMA)--rpath -Wl$(COMMA)$(LOCALROOT)/lib -lncurses" CURSES_CFLAGS="-I$(LOCALROOT)/include -I$(LOCALROOT)/include/ncurses"))

CT_EXTRA_LDFLAGS_FOR_BUILD =
CT_EXTRA_LDFLAGS_FOR_HOST =
CT_HOST_TRIPLET =

# keep in sync with configure.ac
SED_SRCDIR_SUBSTITUTIONS = \
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
	$(MKDIR_P) $(dir $@)
	$(SED) \
	  " \
	    s|!CT_LOCALROOT!|$(LOCALROOT)|; \
	    s|!CT_OUTPUT_DIR!|$(BOOTSTRAPROOT)|; \
	    s|!CT_JOBS!|$(CHIPCRAFT_TOOLCHAIN_CPUS)|; \
	    s|!CT_BUILD_TRIPLET!|$(CHIPCRAFT_TOOLCHAIN_LINUX_TRIPLET)|; \
	    s|!CT_HOST_TRIPLET!|$(CHIPCRAFT_TOOLCHAIN_BUILDSYSTEM_TRIPLET)|; \
	    s|!CT_BITNESS!|$(CHIPCRAFT_TOOLCHAIN_BITNESS)|; \
	    s|!CT_KERNEL_VERSION!|$(CHIPCRAFT_TOOLCHAIN_KERNEL)|; \
	    s|!CT_KERNEL_MAJOR!|$(CHIPCRAFT_TOOLCHAIN_KERNEL_MAJOR)|; \
	    s|!CT_KERNEL_MINOR!|$(CHIPCRAFT_TOOLCHAIN_KERNEL_MINOR)|; \
	    $(SED_SRCDIR_SUBSTITUTIONS) \
	  " \
	$(word 1,$^) > $@ \
	$(EOL)

$(BOOTSTRAPROOT)/bin/$(CHIPCRAFT_TOOLCHAIN_BUILDSYSTEM_TRIPLET)-gcc \
$(BOOTSTRAPROOT)/bin/$(CHIPCRAFT_TOOLCHAIN_BUILDSYSTEM_TRIPLET)-g++: \
  $(WORKDIR)/toolchain/host/.config \
  $(LOCALROOT)/bin/ct-ng \
  $(EOL)
	$(CD) $(dir $(word 1,$^)) \
	&& $(word 2,$^) build \
	$(EOL)

host: \
  $(BOOTSTRAPROOT)/bin/$(CHIPCRAFT_TOOLCHAIN_BUILDSYSTEM_TRIPLET)-gcc \
  $(BOOTSTRAPROOT)/bin/$(CHIPCRAFT_TOOLCHAIN_BUILDSYSTEM_TRIPLET)-g++

$(WORKDIR)/toolchain/mips/%/.config: \
  $(abs_top_srcdir)/resources/configs/mips.in \
  $(EOL)
	$(MKDIR_P) $(dir $@)
	$(SED) \
	  " \
	    s|!CT_OUTPUT_DIR!|$(OUTPUTROOT)|; \
	    s|!CT_JOBS!|$(CHIPCRAFT_TOOLCHAIN_CPUS)|; \
	    s|!CT_BUILD_TRIPLET!|$(CHIPCRAFT_TOOLCHAIN_BUILDSYSTEM_TRIPLET)|; \
	    s|!CT_HOST_TRIPLET!|$(CT_HOST_TRIPLET)|; \
	    $(SED_SRCDIR_SUBSTITUTIONS) \
	  " \
	$(word 1,$^) > $@ \
	$(EOL)

if CHIPCRAFT_TOOLCHAIN_LINUX
# one variable assignment per rule!
$(WORKDIR)/toolchain/mips/linux/.config: \
  CT_HOST_TRIPLET = $(CHIPCRAFT_TOOLCHAIN_LINUX_TRIPLET)

$(OUTPUTROOT)/$(CHIPCRAFT_TOOLCHAIN_LINUX_TRIPLET): \
  PATH := $(BOOTSTRAPROOT)/bin:$(LOCALROOT)/bin:$(BACKUP_PATH)
$(OUTPUTROOT)/$(CHIPCRAFT_TOOLCHAIN_LINUX_TRIPLET): \
  $(WORKDIR)/toolchain/mips/linux/.config \
  $(LOCALROOT)/bin/ct-ng \
  $(BOOTSTRAPROOT)/bin/$(CHIPCRAFT_TOOLCHAIN_BUILDSYSTEM_TRIPLET)-gcc \
  $(EOL)
	$(CD) $(dir $(word 1,$^)) \
	&& $(word 2,$^) build \
	$(EOL)

LINUX_DEPENDENCY = $(OUTPUTROOT)/$(CHIPCRAFT_TOOLCHAIN_LINUX_TRIPLET)
else !CHIPCRAFT_TOOLCHAIN_LINUX
LINUX_DEPENDENCY =
endif !CHIPCRAFT_TOOLCHAIN_LINUX

if CHIPCRAFT_TOOLCHAIN_WINDOWS
$(WORKDIR)/toolchain/mips/windows/.config: \
  CT_HOST_TRIPLET = $(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET)

$(OUTPUTROOT)/$(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET): \
  PATH := $(BOOTSTRAPROOT)/bin:$(LOCALROOT)/bin:$(BACKUP_PATH)
$(OUTPUTROOT)/$(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET): \
  $(WORKDIR)/toolchain/mips/windows/.config \
  $(LOCALROOT)/bin/ct-ng \
  $(BOOTSTRAPROOT)/bin/$(CHIPCRAFT_TOOLCHAIN_BUILDSYSTEM_TRIPLET)-gcc \
  $(EOL)
	$(CD) $(dir $(word 1,$^)) \
	&& $(word 2,$^) build \
	$(EOL)

WINDOWS_DEPENDENCY = $(OUTPUTROOT)/$(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET)
else !CHIPCRAFT_TOOLCHAIN_WINDOWS
WINDOWS_DEPENDENCY =
endif !CHIPCRAFT_TOOLCHAIN_WINDOWS

linux: $(LINUX_DEPENDENCY)

windows: $(WINDOWS_DEPENDENCY)

all: linux windows

