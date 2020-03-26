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

# directory where all the building shall be done
WORKDIR = $(abs_top_builddir)/workdir
# directory where 3rd party tools used for
# building the toolchain shall be installed
LOCALROOT = $(abs_top_builddir)/localroot
# directory where finished toolchains will be installed
OUTPUTROOT = $(abs_top_builddir)/outputroot

export PATH=$(LOCALROOT)/bin:$(PATH)

# handle changes in configure.ac
$(abs_top_srcdir)/configure: \
  $(abs_top_srcdir)/configure.ac \
  $(abs_top_srcdir)/aclocal.m4 \
  $(EOL)
	$(CD) '$(abs_top_srcdir)' \
	&& autoconf -I m4 \
	$(EOL)

$(WORKDIR):
	$(MKDIR_P) $@

$(WORKDIR)/%/: \
  $(WORKDIR)
	$(MKDIR_P) $@

$(LOCALROOT):
	$(MKDIR_P) $@

$(OUTPUTROOT):
	$(MKDIR_P) $@


# generic installer
$(WORKDIR)/%/Makefile: \
  $(WORKDIR)/%/ \
  $(COMPONENT_SRCDIR)/configure \
  $(COMPONENT_PREREQUISITES) \
  $(EOL)
	$(CD) '$(COMPONENT_SRCDIR)' \
	&& $(word 2,$^) \
	  --prefix $(LOCALROOT) \
	$(EOL)

$(WORKDIR)/%/$(COMPONENT_BUILT_BIN): \
  $(WORKDIR)/%/Makefile \
  $(EOL)
	$(MAKE) -C '$(dir $(word 1,$^))'

$(LOCALROOT)/bin/%: \
  $(WORKDIR)/%/$(COMPONENT_BUILT_BIN) \
  $(EOL)
	$(MAKE) -C '$(WORKDIR)/$*' \
	  prefix=$(LOCALROOT) \
	  install \
	  $(EOL)

need_bin_%: $(LOCALROOT)/bin/%

need_bin_m4: COMPONENT_SRCDIR = $(CHIPCRAFT_TOOLCHAIN_M4_SRCDIR)
need_bin_m4: COMPONENT_PREREQUISITES =
need_bin_m4: COMPONENT_BUILT_BIN = src/m4

need_bin_autoconf: COMPONENT_SRCDIR = $(CHIPCRAFT_TOOLCHAIN_AUTOCONF_SRCDIR)
need_bin_autoconf: COMPONENT_PREREQUISITES = need_bin_m4
need_bin_autoconf: COMPONENT_BUILT_BIN = bin/autoconf

need_bin_automake: COMPONENT_SRCDIR = $(CHIPCRAFT_TOOLCHAIN_AUTOMAKE_SRCDIR)
need_bin_automake: COMPONENT_PREREQUISITES = need_bin_m4 need_bin_autoconf
need_bin_automake: COMPONENT_BUILT_BIN = bin/automake

need_bin_libtool: COMPONENT_SRCDIR = $(CHIPCRAFT_TOOLCHAIN_LIBTOOL_SRCDIR)
need_bin_libtool: \
  COMPONENT_PREREQUISITES = need_bin_m4 need_bin_autoconf need_bin_automake
need_bin_libtool: COMPONENT_BUILT_BIN = libtool

need_bin_make: COMPONENT_SRCDIR = $(CHIPCRAFT_TOOLCHAIN_MAKE_SRCDIR)
need_bin_make: \
  COMPONENT_PREREQUISITES = \
    need_bin_m4 \
    need_bin_autoconf \
    need_bin_automake \
    need_bin_libtool
need_bin_make: COMPONENT_BUILT_BIN = make

AUTOTOOLS = \
  need_bin_m4 \
  need_bin_autoconf \
  need_bin_automake \
  need_bin_libtool \
  need_bin_make \
  $(EOL)

need_bin_gettext: COMPONENT_SRCDIR = $(CHIPCRAFT_TOOLCHAIN_GETTEXT_SRCDIR)
need_bin_gettext: COMPONENT_PREREQUISITES = $(AUTOTOOLS)
need_bin_gettext: COMPONENT_BUILT_BIN = gettext-runtime/src/gettext

need_bin_bison: COMPONENT_SRCDIR = $(CHIPCRAFT_TOOLCHAIN_BISON_SRCDIR)
need_bin_bison: COMPONENT_PREREQUISITES = $(AUTOTOOLS) need_bin_gettext
need_bin_bison: COMPONENT_BUILT_BIN = src/bison

need_bin_flex: COMPONENT_SRCDIR = $(CHIPCRAFT_TOOLCHAIN_FLEX_SRCDIR)
need_bin_flex: COMPONENT_PREREQUISITES = $(AUTOTOOLS) need_bin_gettext need_bin_bison
need_bin_flex: COMPONENT_BUILT_BIN = src/flex

need_bin_gawk: COMPONENT_SRCDIR = $(CHIPCRAFT_TOOLCHAIN_GAWK_SRCDIR)
need_bin_gawk: \
  COMPONENT_PREREQUISITES = \
    $(AUTOTOOLS) need_bin_gettext need_bin_bison need_bin_flex
need_bin_gawk: COMPONENT_BUILT_BIN = src/flex

TEXTTOOLS = \
  need_bin_gettext \
  need_bin_bison \
  need_bin_flex \
  need_bin_gawk \
  $(EOL)

# install ncurses
$(WORKDIR)/ncurses/Makefile: \
  $(WORKDIR) \
  $(WORKDIR)/ncurses/ \
  $(CHIPCRAFT_TOOLCHAIN_NCURSES_SRCDIR)/configure \
  $(AUTOTOOLS) \
  $(TEXTTOOLS) \
  $(EOL)
	$(CD) '$(word 2,$^)' \
	&& $(word 3,$^) \
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

# install ct-ng
$(WORKDIR)/ct-ng/Makefile: \
  $(WORKDIR) \
  $(WORKDIR)/ct-ng/ \
  $(CHIPCRAFT_TOOLCHAIN_CT_NG_SRCDIR)/configure \
  $(AUTOTOOLS) \
  $(TEXTTOOLS) \
  $(LOCALROOT)/lib/libncurses.so \
  $(EOL)
	$(CD) '$(word 2,$^)' \
	&& $(word 3,$^) \
	  --prefix $(LOCALROOT) \
	  CURSES_LIBS="-L$(LOCALROOT)/lib -Wl,--rpath -Wl,$(LOCALROOT)/lib -lncurses" \
	  CURSES_CFLAGS="-I$(LOCALROOT)/include -I$(LOCALROOT)/include/ncurses" \
	$(EOL)

$(WORKDIR)/ct-ng/ct-ng: \
  $(WORKDIR)/ct-ng/Makefile \
  $(EOL)
	$(MAKE) -C '$(dir $(word 1,$^))' \
	CPPFLAGS+="-I$(LOCALROOT)/include -I$(LOCALROOT)/include/ncurses" \
	$(EOL)

$(LOCALROOT)/bin/ct-ng: \
  $(WORKDIR)/ct-ng/ct-ng \
  $(EOL)
	$(MAKE) -C '$(WORKDIR)/ct-ng' \
	  prefix=$(LOCALROOT) \
	  install \
	  $(EOL)

CT_EXTRA_LDFLAGS_FOR_BUILD =
CT_EXTRA_LDFLAGS_FOR_HOST =
CT_HOST_TRIPLET =

$(CT_TARBALLS_STORAGE):
	$(MKDIR_P) $@

$(WORKDIR)/toolchain/%/:
	$(MKDIR_P) $@

# keep in sync with configure.ac
SED_SRCDIR_SUBSTITUTIONS = \
  " \
    s|!CT_M4_URL!|$(CHIPCRAFT_TOOLCHAIN_M4_SRCDIR)|; \
    s|!CT_AUTOCONF_URL!|$(CHIPCRAFT_TOOLCHAIN_AUTOCONF_SRCDIR)|; \
    s|!CT_AUTOMAKE_URL!|$(CHIPCRAFT_TOOLCHAIN_AUTOMAKE_SRCDIR)|; \
    s|!CT_LIBTOOL_URL!|$(CHIPCRAFT_TOOLCHAIN_LIBTOOL_SRCDIR)|; \
    s|!CT_MAKE_URL!|$(CHIPCRAFT_TOOLCHAIN_MAKE_SRCDIR)|; \
    s|!CT_BINUTILS_URL!|$(CHIPCRAFT_TOOLCHAIN_BINUTILS_SRCDIR)|; \
    s|!CT_BISON_URL!|$(CHIPCRAFT_TOOLCHAIN_BISON_SRCDIR)|; \
    s|!CT_CLOOG_URL!|$(CHIPCRAFT_TOOLCHAIN_CLOOG_SRCDIR)|; \
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
    s|!CT_MIPS_BINUTILS_URL!|$(CHIPCRAFT_TOOLCHAIN_MIPS_BINUTILS_SRCDIR)|; \
    s|!CT_MIPS_GCC_URL!|$(CHIPCRAFT_TOOLCHAIN_MIPS_GCC_SRCDIR)|; \
    s|!CT_MIPS_NEWLIB_URL!|$(CHIPCRAFT_TOOLCHAIN_MIPS_NEWLIB_SRCDIR)|; \
    s|!CT_LINUX_URL!|$(CHIPCRAFT_TOOLCHAIN_LINUX_SRCDIR)|; \
  "

$(WORKDIR)/toolchain/host/.config: \
  $(WORKDIR)/toolchain/host/ \
  $(abs_top_srcdir)/resources/configs/host.in \
  $(CT_TARBALLS_STORAGE) \
  $(EOL)
	$(SED) \
	  " \
	    s|!CT_OUTPUT_DIR!|$(LOCALROOT)|; \
	    s|!CT_JOBS!|$(CHIPCRAFT_TOOLCHAIN_CPUS)|; \
	    s|!CT_BUILD_TRIPLET!|$(CHIPCRAFT_TOOLCHAIN_LINUX_TRIPLET)|; \
	    s|!CT_HOST_TRIPLET!|$(CHIPCRAFT_TOOLCHAIN_BUILDSYSTEM_TRIPLET)|; \
	    s|!CT_BITNESS!|$(CHIPCRAFT_TOOLCHAIN_BITNESS)|; \
	    s|!CT_KERNEL_VERSION!|$(CHIPCRAFT_TOOLCHAIN_KERNEL)|; \
	    s|!CT_KERNEL_MAJOR!|$(CHIPCRAFT_TOOLCHAIN_KERNEL_MAJOR)|; \
	    s|!CT_KERNEL_MINOR!|$(CHIPCRAFT_TOOLCHAIN_KERNEL_MINOR)|; \
	  " \
	  $(SED_SRCDIR_SUBSTITUTIONS) \
	$(word 2,$^) > $@ \
	$(EOL)

$(LOCALROOT)/bin/$(CHIPCRAFT_TOOLCHAIN_BUILDSYSTEM_TRIPLET)-gcc \
$(LOCALROOT)/bin/$(CHIPCRAFT_TOOLCHAIN_BUILDSYSTEM_TRIPLET)-g++: \
  $(WORKDIR)/toolchain/host/.config \
  $(LOCALROOT)/bin/ct-ng \
  $(EOL)
	$(CD) $(dir $(word 1,$^)) \
	&& $(word 2,$^) build \
	$(EOL)

host: \
  $(LOCALROOT)/bin/$(CHIPCRAFT_TOOLCHAIN_BUILDSYSTEM_TRIPLET)-gcc \
  $(LOCALROOT)/bin/$(CHIPCRAFT_TOOLCHAIN_BUILDSYSTEM_TRIPLET)-g++

$(WORKDIR)/toolchain/mips/%/.config: \
  $(WORKDIR)/toolchain/mips/%/ \
  $(abs_top_srcdir)/resources/configs/mips.in \
  $(CT_TARBALLS_STORAGE) \
  $(EOL)
	$(SED) \
	  " \
	    s|!CT_TARBALLS_STORAGE!|$(CT_TARBALLS_STORAGE)|; \
	    s|!CT_OUTPUT_DIR!|$(OUTPUTROOT)|; \
	    s|!CT_JOBS!|$(CHIPCRAFT_TOOLCHAIN_CPUS)|; \
	    s|!CT_EXTRA_LDFLAGS_FOR_BUILD!|$(CT_EXTRA_LDFLAGS_FOR_BUILD)|; \
	    s|!CT_EXTRA_LDFLAGS_FOR_HOST!|$(CT_EXTRA_LDFLAGS_FOR_HOST)|; \
	    s|!CT_BUILD_TRIPLET!|$(CHIPCRAFT_TOOLCHAIN_BUILDSYSTEM_TRIPLET)|; \
	    s|!CT_HOST_TRIPLET!|$(CT_HOST_TRIPLET)|; \
	    s|!CT_BINUTILS_URL!|$(CHIPCRAFT_TOOLCHAIN_MIPS_BINUTILS_GDB_SRCDIR)|; \
	    s|!CT_NEWLIB_URL!|$(CHIPCRAFT_TOOLCHAIN_MIPS_NEWLIB_SRCDIR)|; \
	    s|!CT_GCC_URL!|$(CHIPCRAFT_TOOLCHAIN_MIPS_GCC_SRCDIR)|; \
	    s|!CT_GDB_URL!|$(CHIPCRAFT_TOOLCHAIN_MIPS_BINUTILS_GDB_SRCDIR)|; \
	  " \
	$(word 2,$^) > $@ \
	$(EOL)

if CHIPCRAFT_TOOLCHAIN_LINUX
# one variable assignment per rule!
$(WORKDIR)/toolchain/mips/linux/.config: \
  CT_HOST_TRIPLET = $(CHIPCRAFT_TOOLCHAIN_LINUX_TRIPLET)

$(OUTPUTROOT)/$(CHIPCRAFT_TOOLCHAIN_LINUX_TRIPLET): \
  $(WORKDIR)/toolchain/mips/linux/.config \
  $(LOCALROOT)/bin/ct-ng \
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
  $(WORKDIR)/toolchain/mips/windows/.config \
  $(LOCALROOT)/bin/ct-ng \
  $(EOL)
	$(CD) $(dir $(word 1,$^)) \
	&& $(word 2,$^) build \
	$(EOL)

WINDOWS_DEPENDENCY = $(OUTPUTROOT)/$(CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET)
else !CHIPCRAFT_TOOLCHAIN_WINDOWS
WINDOWS_DEPENDENCY =
endif !CHIPCRAFT_TOOLCHAIN_WINDOWS

#linux: host $(LINUX_DEPENDENCY)
#
#windows: host $(WINDOWS_DEPENDENCY)
#
#all: linux windows

