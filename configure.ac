dnl autoconf initialization
dnl note that many macros can be very unstable in handling whitespace
dnl general rule seems to be: ^<MACRO_NAME>(<first argument>, $
dnl last argument should be foolowed by dnl, to strip newline
AC_PREREQ(2.58) dnl at least autoconf v2.58 is required
dnl initialize the autoconf system
dnl project version is either git commit hash or "unknown"
AC_INIT([chipcraft-toolchain],
  m4_normalize(m4_esyscmd([ \
    git log -n 1 --format=%H 2>/dev/null \
    | awk -v version="unknown" '{print} END { if (NR==0) {print version} }'dnl
  ])),
  [office@chipcraft-ic.com],
  [chipcraft-toolchain-dist],
  [chipcraft-ic.com]dnl
)
AC_CONFIG_MACRO_DIR([m4]) dnl $(srcdir)/m4 directory will contain custom m4
                          dnl macros used during the configuration stage
AX_SILENT_MODE([on]) dnl less verbose configure output
dnl get 'Makefile.in' from 'Makefile.in'
dnl initialize automake with given flags
dnl foreign : don't complain about some missing files
dnl subdir-objects : build objects in subdirs, not in root directory
dnl tar-pax : tar format used when building distribution archive
dnl dist-bzip2 : compress the distribution archive with bzip2
dnl -Wall : warn about everything, TODO: consider lowering that
dnl note that AM_INIT_AUTOMAKE is very sensitive to whitespace
AM_INIT_AUTOMAKE([foreign subdir-objects tar-pax dist-bzip2 -Wall])
AM_SILENT_RULES([yes]) dnl less verbose automake
AC_CONFIG_FILES([Makefile]) dnl output of configuration stage as Makefile
                            dnl from input file 'Makefile.in'

dnl start configuration of the project

dnl ensure we know where the sources are
AS_VAR_SET(ABS_TOP_SRCDIR, `cd ${srcdir} && pwd`)
dnl assume pwd is the build directory
AS_VAR_SET(ABS_TOP_BUILDDIR, `pwd`)

dnl get information about our buildsystem
AC_CANONICAL_BUILD
AS_VAR_SET(CHIPCRAFT_TOOLCHAIN_BUILDSYSTEM_TRIPLET,
  "${build_cpu}-chipcraft-linux-gnu"dnl
)
AC_SUBST(CHIPCRAFT_TOOLCHAIN_BUILDSYSTEM_TRIPLET)
dnl is cpu 64-bit or 32-bit?
AS_CASE(${build_cpu},
  [x86_64],
  [AS_VAR_SET(CHIPCRAFT_TOOLCHAIN_BITNESS, '64')],
  [AS_VAR_SET(CHIPCRAFT_TOOLCHAIN_BITNESS, '32')]
)
AC_SUBST(CHIPCRAFT_TOOLCHAIN_BITNESS)
AS_VAR_SET(CHIPCRAFT_TOOLCHAIN_CPUS,
  m4_normalize(m4_esyscmd([nproc]))
)
AC_SUBST(CHIPCRAFT_TOOLCHAIN_CPUS)
dnl TODO do not use sed directly
AS_VAR_SET(VERSION,
  m4_normalize(m4_esyscmd([uname -r | sed 's|-.*||']))
)
AX_SPLIT_VERSION
dnl when we build name of kernel headers package
dnl if patch value is equal zero
dnl it and the final dot are ommitted
dnl TODO do not use sed directly
AS_VAR_SET(CHIPCRAFT_TOOLCHAIN_KERNEL,
  m4_normalize(m4_esyscmd([uname -r | sed 's|-.*||' | sed 's|\.0$||']))
)
AS_VAR_SET(CHIPCRAFT_TOOLCHAIN_KERNEL_MAJOR, "${AX_MAJOR_VERSION}")
AS_VAR_SET(CHIPCRAFT_TOOLCHAIN_KERNEL_MINOR, "${AX_MINOR_VERSION}")
AS_UNSET(VERSION)
AC_SUBST(CHIPCRAFT_TOOLCHAIN_KERNEL)
AC_SUBST(CHIPCRAFT_TOOLCHAIN_KERNEL_MAJOR)
AC_SUBST(CHIPCRAFT_TOOLCHAIN_KERNEL_MINOR)

dnl dependency checks

AX_CHECK_GNU_MAKE([], AC_MSG_ERROR([GNU Make is required to build project.]))
AC_PROG_CC dnl we need a compiler
AC_PROG_LN_S dnl check for a way to create links
AC_PROG_MKDIR_P dnl check for a way to create directories
AC_PROG_SED dnl check for sed
AX_PROG_SSH dnl ssh is used in git urls

dnl check that git supports 'git ls-remote --exit-code'
dnl this macro used only for custom error messages
AC_PATH_PROGS_FEATURE_CHECK([GIT],
  [git],
  [
    AS_IF([ \
        sh ${ABS_TOP_SRCDIR}/resources/scripts/git-check "${ac_path_GIT}" \
        &> /dev/null dnl
      ],
      [
        AS_VAR_SET(GIT, "${ac_path_GIT}")
        AS_VAR_SET(ac_cv_path_GIT, "${ac_path_GIT}")
        AS_VAR_SET(ac_path_GIT_found, :)
      ]dnl
    )
  ],
  [AC_MSG_ERROR([No version of git supporting -C or ls-remote --exit-code.])],
  [${PATH}]dnl
)
AC_SUBST(GIT)

dnl configure what should be built

AC_ARG_ENABLE([linux-toolchain],
  [
    AS_HELP_STRING([--disable-linux-toolchain],
      [do not build static toolchain for linux]dnl
    )
  ],
  [],
  [AS_VAR_SET(enable_linux_toolchain, yes)]
)
AC_ARG_ENABLE([windows-toolchain],
  [
    AS_HELP_STRING([--disable-windows-toolchain],
      [do not build static toolchain for windows x86 32-bit]dnl
    )
  ],
  [],
  [AS_VAR_SET(enable_windows_toolchain, yes)]dnl
)
dnl pass the choices to Makefile
AM_CONDITIONAL([CHIPCRAFT_TOOLCHAIN_LINUX],
  [test "x${enable_linux_toolchain}" = "xyes"]dnl
)
AM_CONDITIONAL([CHIPCRAFT_TOOLCHAIN_WINDOWS],
  [test "x${enable_windows_toolchain}" = "xyes"]dnl
)


dnl for linux taken from found compiler
AX_CHIPCRAFT_ARG_DEFAULT_VAR([CHIPCRAFT_TOOLCHAIN_LINUX_TRIPLET],
  [Target triplet used by crosstool-ng for linux build],
  [`${CC} -dumpmachine`]dnl
)
dnl and for windows
AX_CHIPCRAFT_ARG_DEFAULT_VAR([CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET],
  [Target triplet used by crosstool-ng for windows build],
  ["i686-w64-mingw32"]dnl default for mingw-based 32-bit build
)

dnl test whether compilers for used triplets exist

dnl gcc for linux build is checked always
dnl this macro used only for custom error messages
dnl check if found program is executable
dnl (just a basic sanity check, since ct-ng also checks it)
AC_PATH_PROGS_FEATURE_CHECK([LINUX_GCC],
  [${CHIPCRAFT_TOOLCHAIN_LINUX_TRIPLET}-gcc],
  [
    AS_IF([AS_EXECUTABLE_P(${ac_path_LINUX_GCC})],
      [
        ac_cv_path_LINUX_GCC="${ac_path_LINUX_GCC}"
        ac_path_LINUX_GCC_found=:
      ]dnl
    )
  ],
  [AC_MSG_ERROR([Cannot find compiler for linux in provided path.])],
  [${PATH}]dnl
)
dnl gcc for windows build is tested only if windows build is enabled
AS_IF([test "x${enable_windows_toolchain}" = "xyes"],
  [
    AC_PATH_PROGS_FEATURE_CHECK([WINDOWS_GCC],
      [${CHIPCRAFT_TOOLCHAIN_WINDOWS_TRIPLET}-gcc],
      [
        AS_IF([AS_EXECUTABLE_P(${ac_path_WINDOWS_GCC})],
          [
            ac_cv_path_WINDOWS_GCC="${ac_path_WINDOWS_GCC}"
            ac_path_WINDOWS_GCC_found=:
          ]dnl
        )
      ],
      [AC_MSG_ERROR([Cannot find compiler for windows in provided path. Ensure mingw-w64 toolchain for i686 is installed.])],
      [${PATH}]dnl
    )
  ]
)

dnl check whether dependencies are present in given directories
dnl if not, initialize them from given urls
dnl TODO: change locations from /home/... to github
dnl call: AX_CHIPCRAFT_CHECK_DEPENDENCY([</path/to/check/],
dnl         [<git repo to clone>]
dnl       )

dnl first, check core buildsystem components
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/m4],
  [chipcraft-git:REPOSITORIES/chipcraft-m4/],
  [CHIPCRAFT_TOOLCHAIN_M4_SRCDIR]dnl
)
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/autoconf],
  [chipcraft-git:REPOSITORIES/chipcraft-autoconf/],
  [CHIPCRAFT_TOOLCHAIN_AUTOCONF_SRCDIR]dnl
)
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/automake],
  [chipcraft-git:REPOSITORIES/chipcraft-automake/],
  [CHIPCRAFT_TOOLCHAIN_AUTOMAKE_SRCDIR]dnl
)
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/libtool],
  [chipcraft-git:REPOSITORIES/chipcraft-libtool/],
  [CHIPCRAFT_TOOLCHAIN_LIBTOOL_SRCDIR]dnl
)
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/make],
  [chipcraft-git:REPOSITORIES/chipcraft-make/],
  [CHIPCRAFT_TOOLCHAIN_MAKE_SRCDIR]dnl
)
dnl next, check build toolchain components
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/linux],
  [chipcraft-git:REPOSITORIES/chipcraft-linux/],
  [CHIPCRAFT_TOOLCHAIN_LINUX_SRCDIR]dnl
)
AS_VAR_SET_IF(GIT,
  [${GIT} -C ${ABS_TOP_BUILDDIR}/components/linux checkout v${CHIPCRAFT_TOOLCHAIN_KERNEL}],
  [AC_MSG_ERROR([git presence must be tested before dependency check macro call])]dnl
)
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/binutils],
  [chipcraft-git:REPOSITORIES/chipcraft-mips-binutils/],
  [CHIPCRAFT_TOOLCHAIN_BINUTILS_SRCDIR]dnl
)
AS_VAR_SET_IF(GIT,
  [${GIT} -C ${ABS_TOP_BUILDDIR}/components/binutils checkout chipcraft-binutils-2.34],
  [AC_MSG_ERROR([git presence must be tested before dependency check macro call])]dnl
)
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/bison],
  [chipcraft-git:REPOSITORIES/chipcraft-bison/],
  [CHIPCRAFT_TOOLCHAIN_BISON_SRCDIR]dnl
)
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/cloog],
  [chipcraft-git:REPOSITORIES/chipcraft-cloog/],
  [CHIPCRAFT_TOOLCHAIN_CLOOG_SRCDIR]dnl
)
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/flex],
  [chipcraft-git:REPOSITORIES/chipcraft-flex/],
  [CHIPCRAFT_TOOLCHAIN_FLEX_SRCDIR]dnl
)
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/gawk],
  [chipcraft-git:REPOSITORIES/chipcraft-gawk/],
  [CHIPCRAFT_TOOLCHAIN_GAWK_SRCDIR]dnl
)
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/gcc],
  [chipcraft-git:REPOSITORIES/chipcraft-mips-gcc/],
  [CHIPCRAFT_TOOLCHAIN_GCC_SRCDIR]dnl
)
AS_VAR_SET_IF(GIT,
  [${GIT} -C ${ABS_TOP_BUILDDIR}/components/gcc checkout chipcraft-gcc-9.3],
  [AC_MSG_ERROR([git presence must be tested before dependency check macro call])]dnl
)
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/gettext],
  [chipcraft-git:REPOSITORIES/chipcraft-gettext/],
  [CHIPCRAFT_TOOLCHAIN_GETTEXT_SRCDIR]dnl
)
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/glibc],
  [chipcraft-git:REPOSITORIES/chipcraft-glibc/],
  [CHIPCRAFT_TOOLCHAIN_GLIBC_SRCDIR]dnl
)
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/gmp],
  [chipcraft-git:REPOSITORIES/chipcraft-gmp/],
  [CHIPCRAFT_TOOLCHAIN_GMP_SRCDIR]dnl
)
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/isl],
  [chipcraft-git:REPOSITORIES/chipcraft-isl/],
  [CHIPCRAFT_TOOLCHAIN_ISL_SRCDIR]dnl
)
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/libiconv],
  [chipcraft-git:REPOSITORIES/chipcraft-libiconv/],
  [CHIPCRAFT_TOOLCHAIN_LIBICONV_SRCDIR]dnl
)
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/mpc],
  [chipcraft-git:REPOSITORIES/chipcraft-mpc/],
  [CHIPCRAFT_TOOLCHAIN_MPC_SRCDIR]dnl
)
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/mpfr],
  [chipcraft-git:REPOSITORIES/chipcraft-mpfr/],
  [CHIPCRAFT_TOOLCHAIN_MPFR_SRCDIR]dnl
)
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/ncurses],
  [chipcraft-git:REPOSITORIES/chipcraft-ncurses/],
  [CHIPCRAFT_TOOLCHAIN_NCURSES_SRCDIR]dnl
)
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/zlib],
  [chipcraft-git:REPOSITORIES/chipcraft-zlib/],
  [CHIPCRAFT_TOOLCHAIN_ZLIB_SRCDIR]dnl
)

dnl check final toolchain components
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/mips-binutils-gdb],
  [chipcraft-git:REPOSITORIES/chipcraft-mips-binutils-gdb/],
  [CHIPCRAFT_TOOLCHAIN_MIPS_BINUTILS_GDB_SRCDIR]dnl
)
AC_SUBST(CHIPCRAFT_TOOLCHAIN_MIPS_BINUTILS_GDB_SRCDIR)
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/mips-gcc],
  [chipcraft-git:REPOSITORIES/chipcraft-mips-gcc/],
  [CHIPCRAFT_TOOLCHAIN_MIPS_GCC_SRCDIR]dnl
)
AC_SUBST(CHIPCRAFT_TOOLCHAIN_MIPS_GCC_SRCDIR)
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/mips-newlib],
  [chipcraft-git:REPOSITORIES/chipcraft-mips-newlib/],
  [CHIPCRAFT_TOOLCHAIN_MIPS_NEWLIB_SRCDIR]dnl
)
AC_SUBST(CHIPCRAFT_TOOLCHAIN_MIPS_NEWLIB_SRCDIR)
dnl TODO: future RISC-V extensions
dnl AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_SRCDIR}/components/riscv-binutils-gdb],
dnl   [chipcraft-git:REPOSITORIES/chipcraft-riscv-binutils-gdb/],
dnl   [CHIPCRAFT_TOOLCHAIN_RISCV_BINUTILS_GDB_SRCDIR]dnl
dnl )
dnl AC_SUBST(CHIPCRAFT_TOOLCHAIN_RISCV_BINUTILS_GDB_SRCDIR)
dnl AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_SRCDIR}/components/riscv-gcc],
dnl   [chipcraft-git:REPOSITORIES/chipcraft-riscv-gcc/],
dnl   [CHIPCRAFT_TOOLCHAIN_RISCV_GCC_SRCDIR]dnl
dnl )
dnl AC_SUBST(CHIPCRAFT_TOOLCHAIN_RISCV_GCC_SRCDIR)
dnl AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_SRCDIR}/components/riscv-newlib],
dnl   [chipcraft-git:REPOSITORIES/chipcraft-riscv-newlib/],
dnl   [CHIPCRAFT_TOOLCHAIN_RISCV_NEWLIB_SRCDIR]dnl
dnl )
dnl AC_SUBST(CHIPCRAFT_TOOLCHAIN_RISCV_NEWLIB_SRCDIR)

dnl check whether our patched crosstool-ng is present
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/chipcraft-crosstool-ng],
  [chipcraft-git:REPOSITORIES/chipcraft-crosstool-ng/],
  [CHIPCRAFT_TOOLCHAIN_CT_NG_SRCDIR]dnl
)
AC_SUBST(CHIPCRAFT_TOOLCHAIN_CT_NG_SRCDIR)

dnl must be called last
AC_OUTPUT dnl executes all operations needed to produce the output Makefile

