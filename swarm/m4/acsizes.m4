AC_DEFUN(md_CHECK_SIZES,
[AC_CHECK_SIZEOF(int, 4)
AC_CHECK_SIZEOF(long, 4)
AC_CHECK_SIZEOF(void *, 4)
if test $ac_cv_sizeof_int = $ac_cv_sizeof_void_p; then
  AC_DEFINE(PTRINT, int)
  AC_DEFINE(PTRUINT, unsigned)
  AC_DEFINE(PTRINTFMT, "%d")
  AC_DEFINE(PTRUINTFMT, "%u")
elif test $ac_cv_sizeof_long = $ac_cv_sizeof_void_p; then
  AC_DEFINE(PTRINT, long)
  AC_DEFINE(PTRUINT, unsigned long)
  AC_DEFINE(PTRINTFMT, "%ld")
  AC_DEFINE(PTRUINTFMT, "%lu")
else
  AC_MSG_ERROR(Neither int nor long have the size of void *)
fi])