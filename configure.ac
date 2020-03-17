dnl autoconf initialization
dnl note that many macros can be very unstable in handling whitespace
dnl general rule seems to be: ^<MACRO_NAME>(<first argument>, $
dnl last argument should be foolowed by dnl, to strip newline
AC_PREREQ(2.58) dnl at least autoconf v2.58 is required
dnl initialize the autoconf system
dnl project version is either git commit hash or "unknown"
AC_INIT([chipcraft-toolchain],
  m4_normalize(m4_esyscmd([git log -n 1 --format=%H 2>/dev/null \
    | awk -v version="unknown" '{print} END { if (NR==0) {print version} }'])),
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

dnl dependency checks

AX_CHECK_GNU_MAKE([], AC_MSG_ERROR([gnu make required to build project]))
AC_PROG_CC dnl we need a compiler
AC_PROG_LN_S dnl check for a way to create links
AC_PROG_MKDIR_P dnl check for a way to create directories
AC_PROG_SED dnl check for sed
AX_PROG_SSH dnl ssh is used in git urls

dnl check that git supports 'git ls-remote --exit-code'
dnl this macro used only for custom error messages
AC_PATH_PROGS_FEATURE_CHECK([GIT], dnl
  [git],
  [
    AS_IF([sh ${ABS_TOP_SRCDIR}/resources/scripts/git-check &> /dev/null],
      [
        ac_cv_path_GIT="${ac_path_GIT}"
        ac_path_GIT_found=:
      ]
    )
  ],
  [AC_MSG_ERROR([no version of git supporting -C or ls-remote --exit-code])],
  [${PATH}]dnl
)

dnl check that libtool exists
dnl libtool is needed by ct-ng
dnl this macro used only for custom error messages
AC_PATH_PROGS_FEATURE_CHECK([LIBTOOLIZE], dnl
  [libtoolize],
  [
    AS_IF([libtoolize --version &> /dev/null],
      [
        ac_cv_path_LIBTOOLIZE="${ac_path_LIBTOOLIZE}"
        ac_path_LIBTOOLIZE_found=:
      ]
    )
  ],
  [AC_MSG_ERROR([libtool not found. libtool can be installed from package manager: sudo apt-get install libtool on debian or ubuntu or sudo yum install libtool on redhat or centos. libtool sources can be found at https://gnu.org/software/libtool])
  ],
  [${PATH}]dnl
)

dnl configure what should be built

AC_ARG_ENABLE([linux-toolchain],
  [AS_HELP_STRING([--disable-linux-toolchain],
    [do not build static toolchain for linux (current host)]dnl
  )],
  [],
  [AS_VAR_SET(enable_linux_toolchain, yes)]
)
AC_ARG_ENABLE([windows-toolchain],
  [AS_HELP_STRING([--disable-windows-toolchain],
    [do not build static toolchain for windows x86 32-bit]dnl
  )],
  [],
  [AS_VAR_SET(enable_windows_toolchain, yes)]dnl
)
dnl pass the choices to Makefile
AM_CONDITIONAL([LINUX_TOOLCHAIN],
  [test "x${enable_linux_toolchain}" = "xyes"]dnl
)
AM_CONDITIONAL([WINDOWS_TOOLCHAIN],
  [test "x${enable_windows_toolchain}" = "xyes"]dnl
)


dnl for linux taken from found compiler
AX_CHIPCRAFT_ARG_DEFAULT_VAR([LINUX_TRIPLET],
  [Target triplet used by crosstool-ng for linux build],
  [`${CC} -dumpmachine`]dnl
)
dnl and for windows
AX_CHIPCRAFT_ARG_DEFAULT_VAR([WINDOWS_TRIPLET],
  [Target triplet used by crosstool-ng for windows build],
  ["i686-w64-mingw32"]dnl default for mingw-based 32-bit build
)

dnl test whether compilers for used triplets exist

dnl gcc for linux build is checked always
dnl this macro used only for custom error messages
dnl check if found program is executable
dnl (just a basic sanity check, since ct-ng also checks it)
AC_PATH_PROGS_FEATURE_CHECK([LINUX_GCC],
  [${LINUX_TRIPLET}-gcc],
  [
    AS_IF([AS_EXECUTABLE_P(${ac_path_LINUX_GCC})],
      [
        ac_cv_path_LINUX_GCC="${ac_path_LINUX_GCC}"
        ac_path_LINUX_GCC_found=:
      ]dnl
    )
  ],
  [AC_MSG_ERROR([cannot find gcc executable for linux in provided path])],
  [${PATH}]dnl
)
dnl gcc for windows build is tested only if windows build is enabled
AS_IF([test "x${enable_windows_toolchain}" = "xyes"],
  [
    AC_PATH_PROGS_FEATURE_CHECK([WINDOWS_GCC],
      [${WINDOWS_TRIPLET}-gcc],
      [
        AS_IF([AS_EXECUTABLE_P(${ac_path_WINDOWS_GCC})],
          [
            ac_cv_path_WINDOWS_GCC="${ac_path_WINDOWS_GCC}"
            ac_path_WINDOWS_GCC_found=:
          ]dnl
        )
      ],
      [AC_MSG_ERROR([cannot find gcc executable for windows in provided path. make sure mingw-w64 toolchain for i686 is installed])],
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
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/mips-binutils-gdb],
  [chipcraft-git:REPOSITORIES/chipcraft-mips-binutils-gdb/],
  [MIPS_BINUTILS_GDB_SRCDIR]dnl
)
AC_SUBST(MIPS_BINUTILS_GDB_SRCDIR)
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/mips-gcc],
  [chipcraft-git:REPOSITORIES/chipcraft-mips-gcc/],
  [MIPS_GCC_SRCDIR]dnl
)
AC_SUBST(MIPS_GCC_SRCDIR)
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/components/mips-newlib],
  [chipcraft-git:REPOSITORIES/chipcraft-mips-newlib/],
  [MIPS_NEWLIB_SRCDIR]dnl
)
AC_SUBST(MIPS_NEWLIB_SRCDIR)
dnl TODO: future RISC-V extensions
dnl AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_SRCDIR}/components/riscv-binutils-gdb],
dnl   [chipcraft-git:REPOSITORIES/chipcraft-riscv-binutils-gdb/],
dnl   [RISCV_BINUTILS_GDB_SRCDIR]dnl
dnl )
dnl AC_SUBST(RISCV_BINUTILS_GDB_SRCDIR)
dnl AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_SRCDIR}/components/riscv-gcc],
dnl   [chipcraft-git:REPOSITORIES/chipcraft-riscv-gcc/],
dnl   [RISCV_GCC_SRCDIR]dnl
dnl )
dnl AC_SUBST(RISCV_GCC_SRCDIR)
dnl AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_SRCDIR}/components/riscv-newlib],
dnl   [chipcraft-git:REPOSITORIES/chipcraft-riscv-newlib/],
dnl   [RISCV_NEWLIB_SRCDIR]dnl
dnl )
dnl AC_SUBST(RISCV_NEWLIB_SRCDIR)

dnl check whether our patched crosstool-ng is present
AX_CHIPCRAFT_CHECK_DEPENDENCY([${ABS_TOP_BUILDDIR}/tools/chipcraft-crosstool-ng],
  [chipcraft-git:REPOSITORIES/chipcraft-crosstool-ng/],
  [CT_NG_SRCDIR]dnl
)
AC_SUBST(CT_NG_SRCDIR)
dnl given crosstool-ng may have already been built
dnl in that case we will only install it to known
dnl location during make step
AM_CONDITIONAL([CT_NG_ALREADY_BUILT],
  [AS_EXECUTABLE_P(${CT_NG_SRCDIR}/ct-ng)]dnl
)

dnl must be called last
AC_OUTPUT dnl executes all operations needed to produce the output Makefile

