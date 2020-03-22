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

$(LOCALROOT):
	$(MKDIR_P) $@

$(OUTPUTROOT):
	$(MKDIR_P) $@

if CHIPCRAFT_TOOLCHAIN_CT_NG_ALREADY_BUILT
# when installing we force prefix because
# we have been given an already configured and built ct-ng sources
$(LOCALROOT)/bin/ct-ng: \
  $(LOCALROOT)
  $(CHIPCRAFT_TOOLCHAIN_CT_NG_SRCDIR)/Makefile \
  $(CHIPCRAFT_TOOLCHAIN_CT_NG_SRCDIR)/ct-ng \
  $(EOL)
	$(MAKE) -C '$(CHIPCRAFT_TOOLCHAIN_CT_NG_SRCDIR)' \
	  prefix=$(LOCALROOT) \
	  install \
	  $(EOL)
else !CHIPCRAFT_TOOLCHAIN_CT_NG_ALREADY_BUILT
# this requires $(CT_NG_SRCDIR) to be writable
# however default path points to builddir
# which should always be writable
$(CHIPCRAFT_TOOLCHAIN_CT_NG_SRCDIR)/configure: \
  $(CHIPCRAFT_TOOLCHAIN_CT_NG_SRCDIR)/bootstrap \
  $(EOL)
	$(IS_DIR) '$(CHIPCRAFT_TOOLCHAIN_CT_NG_SRCDIR)'
	$(CD) '$(CHIPCRAFT_TOOLCHAIN_CT_NG_SRCDIR)' \
	&& $(CHIPCRAFT_TOOLCHAIN_CT_NG_SRCDIR)/bootstrap \
	$(EOL)

$(WORKDIR)/ct-ng:
	$(MKDIR_P) $@

$(WORKDIR)/ct-ng/Makefile: \
  $(WORKDIR) \
  $(WORKDIR)/ct-ng \
  $(CHIPCRAFT_TOOLCHAIN_CT_NG_SRCDIR)/configure \
  $(EOL)
	$(CD) '$(word 2,$^)' \
	&& $(word 3,$^) \
	  --prefix $(LOCALROOT) \
	$(EOL)

$(WORKDIR)/ct-ng/ct-ng: \
  $(WORKDIR)/ct-ng/Makefile \
  $(EOL)
	$(MAKE) -C '$(dir $(word 1,$^))'

$(LOCALROOT)/bin/ct-ng: \
  $(WORKDIR)/ct-ng/ct-ng \
  $(EOL)
	$(MAKE) -C '$(dir $(word 1,$^))' \
	  install \
	  $(EOL)
endif !CHIPCRAFT_TOOLCHAIN_CT_NG_ALREADY_BUILT

# LIBC_A_PATH = $(shell \
#   find /usr/ -path "*/libc.so" -printf "%h" -quit  2>/dev/null \
# )
# LIBC_SO_PATH = $(shell \
#   find /usr/ -path "*/libc.so" -printf "%h" -quit  2>/dev/null \
# )
# LIBM_A_PATH = $(shell \
#   find /usr/ -path "*$(LINUX_TRIPLET)*/libm.a" -printf "%h" -quit 2>/dev/null \
# )

CT_TARBALLS_STORAGE = $(WORKDIR)/tarballs
# CT_NG_EXTRA_LDFLAGS_FOR_BUILD = -L$(LIBC_SO_PATH) -L$(LIBM_A_PATH)
CT_EXTRA_LDFLAGS_FOR_BUILD =
CT_EXTRA_LDFLAGS_FOR_HOST =
CT_HOST_TRIPLET =

$(CT_TARBALLS_STORAGE):
	$(MKDIR_P) $@

$(WORKDIR)/toolchain/%/:
	$(MKDIR_P) $@

$(WORKDIR)/toolchain/host/.config: \
  $(WORKDIR)/toolchain/host/ \
  $(abs_top_srcdir)/resources/configs/host.in \
  $(CT_TARBALLS_STORAGE) \
  $(EOL)
	$(SED) \
	  " \
	    s|!CT_TARBALLS_STORAGE!|$(CT_TARBALLS_STORAGE)|; \
	    s|!CT_OUTPUT_DIR!|$(LOCALROOT)|; \
	    s|!CT_JOBS!|$(CHIPCRAFT_TOOLCHAIN_CPUS)|; \
	    s|!CT_BUILD_TRIPLET!|$(CHIPCRAFT_TOOLCHAIN_LINUX_TRIPLET)|; \
	    s|!CT_HOST_TRIPLET!|$(CHIPCRAFT_TOOLCHAIN_BUILDSYSTEM_TRIPLET)|; \
	    s|!CT_BITNESS!|$(CHIPCRAFT_TOOLCHAIN_BITNESS)|; \
	    s|!CT_KERNEL_VERSION!|$(CHIPCRAFT_TOOLCHAIN_KERNEL)|; \
	    s|!CT_KERNEL_MAJOR!|$(CHIPCRAFT_TOOLCHAIN_KERNEL_MAJOR)|; \
	    s|!CT_KERNEL_MINOR!|$(CHIPCRAFT_TOOLCHAIN_KERNEL_MINOR)|; \
	  " \
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

linux: host $(LINUX_DEPENDENCY)

windows: host $(WINDOWS_DEPENDENCY)

all: linux windows

