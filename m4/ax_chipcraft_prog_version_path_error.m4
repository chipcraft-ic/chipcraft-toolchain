dnl AX_CHIPCRAFT_PROG_VERSION_PATH_ERROR(
dnl   OUTPUT_VARIABLE,
dnl   [program names]
dnl )
dnl ----------------------------------------------
dnl OUTPUT_VARIABLE is in the form of shell variable name.
dnl
dnl Acts a more specialized AC_PATH_PROGS_FEATURE_CHECK
dnl checks specifically for allowing --version argument.
dnl If none pf program names are found, execute AC_MSG_ERROR with suitable
dnl message.
dnl If any program is found, set OUTPUT_VARIABLE to its path.
dnl AC_SUBST the OUTPUT_VARIABLE.
dnl
AC_DEFUN([AX_CHIPCRAFT_PROG_VERSION_PATH_ERROR],
  [
    m4_pushdef([TEMPORARY])
    AC_PATH_PROGS_FEATURE_CHECK([TEMPORARY],
      [$2],
      [
        AS_IF([ \
            "${ac_path_TEMPORARY}" --version \
            &> /dev/null dnl
          ],
          [
            AS_VAR_SET($1, "${ac_path_TEMPORARY}")
            AS_VAR_SET(ac_cv_path_TEMPORARY, "${ac_path_TEMPORARY}")
            AS_VAR_SET(ac_path_TEMPORARY_found, :)
          ]dnl
        )
      ],
      [AC_MSG_ERROR([No version of: $2 supporting --version argument was found.])],
      [${PATH}]dnl
    )
    AC_SUBST($1)
    m4_popdef([TEMPORARY])
  ]
)

