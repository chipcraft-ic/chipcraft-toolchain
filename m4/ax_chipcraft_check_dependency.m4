dnl AX_CHIPCRAFT_CHECK_DEPENDENCY(
dnl   DEFAULT_INSTALLATION_DIRECTORY,
dnl   GIT_SOURCE_REPOSITORY
dnl )
dnl ----------------------------------------------
dnl DEFAULT_INSTALLATION_DIRECTORY is in the form:
dnl   /absolute/path/to/directory
dnl or
dnl   relative/path/to/directory
dnl GIT_SOURCE_REPOSITORY is in the form of git url
dnl as understood by git-clone.
dnl
dnl Execute:
dnl 1. create an argument --with-...-path;
dnl    the '...' part is taken as last token of given
dnl    DEFAULT_INSTALLATION_DIRECTORY;
dnl    this argument allows setting alternate path to
dnl    dependency that will be checked;
dnl    the default value to this argument shall be equal
dnl    to DEFAULT_INSTALLATION_DIRECTORY
dnl 2. check if path from argument exists and contains
dnl    any files in the list: configure, configure.ac
dnl 3. if the previous was not true, use git to clone
dnl    repository given in GIT_SOURCE_REPOSITORY to the
dnl    path given as first argument
dnl It is assumed that location given via --with-...-path
dnl either contains the files or is writable.
dnl
AC_DEFUN([AX_CHIPCRAFT_CHECK_DEPENDENCY],
  [
    m4_pushdef([BASENAME], [m4_normalize(m4_esyscmd([basename $1]))])
    m4_pushdef([HELP_STRING],
      [m4_esyscmd([printf "path to %s project, default: %s" BASENAME $2])]dnl
    )
    dnl no brackets, since we want to evaluate BASENAME
    AC_ARG_WITH(BASENAME-path,
      AS_HELP_STRING(--with-BASENAME-path=DIR, [HELP_STRING]),
      [AS_VAR_SET(ax_chipcraft_dependency_path, "${withval}")],
      [AS_VAR_SET(ax_chipcraft_dependency_path, "$1")]dnl
    )

    AC_CHECK_FILE([${ax_chipcraft_dependency_path}/configure.ac],
      [],
      [
        git clone $2 ${ax_chipcraft_dependency_path}
        AS_UNSET(AS_TR_SH([ac_cv_file_${ax_chipcraft_dependency_path}/configure.ac]))
        AC_CHECK_FILE([${ax_chipcraft_dependency_path}/configure.ac],
          [],
          [AC_MSG_ERROR([BASENAME project is not valid])]dnl
        )
      ]
    )
    AS_UNSET([ax_chipcraft_dependency_path])
    m4_popdef([HELP_STRING])
    m4_popdef([BASENAME])
  ]
)
