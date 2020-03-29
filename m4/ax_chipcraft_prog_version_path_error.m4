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
    AS_VAR_SET(AX_CHIPCRAFT_PROG_VERSION_PATH_ERROR_TEMPORARY, '')
    AC_PATH_PROGS_FEATURE_CHECK([AX_CHIPCRAFT_PROG_VERSION_PATH_ERROR_TEMPORARY],
      [$2],
      [
        AS_IF([ \
            "${ac_path_AX_CHIPCRAFT_PROG_VERSION_PATH_ERROR_TEMPORARY}" --version \
            &> /dev/null dnl
          ],
          [
            AS_VAR_SET($1, "${ac_path_AX_CHIPCRAFT_PROG_VERSION_PATH_ERROR_TEMPORARY}")
            AS_VAR_SET(ac_cv_path_AX_CHIPCRAFT_PROG_VERSION_PATH_ERROR_TEMPORARY, "${ac_path_AX_CHIPCRAFT_PROG_VERSION_PATH_ERROR_TEMPORARY}")
            AS_VAR_SET(ac_path_AX_CHIPCRAFT_PROG_VERSION_PATH_ERROR_TEMPORARY_found, :)
          ]dnl
        )
      ],
      [AC_MSG_ERROR([No version of: $2 supporting --version argument was found.])],
      [${PATH}]dnl
    )
    AC_SUBST($1)
    AS_UNSET(AX_CHIPCRAFT_PROG_VERSION_PATH_ERROR_TEMPORARY)
  ]
)

