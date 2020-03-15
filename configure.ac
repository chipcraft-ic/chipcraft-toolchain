dnl autoconf initialization
dnl note that many macros can be very unstable in handling whitespace
dnl general rule seems to be: ^<MACRO_NAME>(<first argument>, $
dnl last argument should be foolowed by dnl, to strip newline
AC_PREREQ(2.58) dnl at least autoconf v2.58 is required
dnl initialize the autoconf system
dnl project version is either git commit hash or "unknown"
AC_INIT([chipcraft-toolchain],
  m4_esyscmd([git log -n 1 --format="%H" -- . | echo -n "unknown"]),
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

dnl dependency checks

AC_PROG_CC dnl we need a compiler
AC_PROG_SED dnl check for sed
AC_PROG_LN_S dnl check for a way to create links

dnl check that git supports 'git ls-remote --exit-code'
dnl this macro used only for custom error messages
AC_PATH_PROGS_FEATURE_CHECK([GIT], dnl
  [git],
  [
    AS_IF([sh ${ABS_TOP_SRCDIR}/resources/git-check],
      [
        ac_cv_path_GIT="${ac_path_GIT}"
        ac_path_GIT_found=:
      ]
    )
  ],
  [AC_MSG_ERROR([no version of git supporting -C or ls-remote --exit-code])],
  [${PATH}]dnl
)

dnl check whether dependencies are present in given directories
dnl if not, initialize them from given urls
dnl TODO: change locations from /home/... to github
dnl call: AX_CHIPCRAFT_CHECK_DEPENDENCY([</path/to/check/],
dnl         [<git repo to clone>]
dnl       )
AX_CHIPCRAFT_CHECK_DEPENDENCY([components/mips-binutils-gdb],
  [/home/mjemieli/NG/chipcraft/chipcraft-mips-binutils-gdb/]dnl
)
AX_CHIPCRAFT_CHECK_DEPENDENCY([components/mips-gcc],
  [/home/mjemieli/NG/chipcraft/chipcraft-mips-gcc/]dnl
)
AX_CHIPCRAFT_CHECK_DEPENDENCY([components/mips-newlib],
  [/home/mjemieli/NG/chipcraft/chipcraft-mips-newlib/]dnl
)
dnl TODO: future RISC-V extensions
dnl AX_CHIPCRAFT_CHECK_DEPENDENCY([components/riscv-binutils-gdb],
dnl   [/home/mjemieli/NG/chipcraft/chipcraft-riscv-binutils-gdb/]dnl
dnl )
dnl AX_CHIPCRAFT_CHECK_DEPENDENCY([components/riscv-gcc],
dnl   [/home/mjemieli/NG/chipcraft/chipcraft-riscv-gcc/]dnl
dnl )
dnl AX_CHIPCRAFT_CHECK_DEPENDENCY([components/riscv-newlib],
dnl   [/home/mjemieli/NG/chipcraft/chipcraft-riscv-newlib/]dnl
dnl )

dnl check whether our patched crosstool-ng is present
AX_CHIPCRAFT_CHECK_DEPENDENCY([tools/chipcraft-crosstool-ng],
  [/home/mjemieli/NG/chipcraft/chipcraft-crosstool-ng/]dnl
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
      [AC_MSG_ERROR([cannot find gcc executable for windows in provided path])],
      [${PATH}]dnl
    )
  ]
)

dnl must be called last
AC_OUTPUT dnl executes all operations needed to produce the output Makefile
