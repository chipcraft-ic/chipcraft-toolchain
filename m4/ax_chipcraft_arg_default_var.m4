dnl AX_CHIPCRAFT_ARG_DEFAULT_VAR(VARIABLE, DESCRIPTION, DEFAULT)
dnl ----------------------------------------------
dnl Call AC_ARG_VAR with DEFAULT value.
AC_DEFUN([AX_CHIPCRAFT_ARG_DEFAULT_VAR],
  [
    AC_ARG_VAR([$1], [$2, default value: [$3]])

    AS_IF([test "${ac_env_$1_set}" = "set"],
      [AS_VAR_SET($1, "${ac_env_$1_value}")],
      [AS_VAR_SET($1, "$3")]
    )
  ]
)

