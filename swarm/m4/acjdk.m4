AC_DEFUN(vj_FIND_JDK,
[AC_PATH_PROG(JAVAC, javac, missing)
AC_PATH_PROG(JAR, jar, missing)
AC_MSG_CHECKING(for JDK)
if test -z "$jdkdir" ; then
  if test $JAVAC != missing; then
    changequote(,)
    jdkdir=`echo $JAVAC | sed -e 's/\/javac$//' -e 's/\/[^/][^/]*$//'`
    changequote([,])
  fi
fi

test -z "$jdkdir" && jdkdir=no
if test $jdkdir = no; then
  AC_MSG_RESULT(no)
  jdkdir=
  JAVASTUBS=
else
  if test -f $jdkdir/include/jni.h; then
    AC_MSG_RESULT($jdkdir)
  else
    AC_MSG_ERROR([Please use --with-jdkdir to specify location of JDK.])
  fi
  AC_DEFINE(HAVE_JDK)
  JAVASTUBS=stubs
  test $JAR = missing && JAR=$jdkdir/bin/jar
  test $JAVAC = missing && JAVAC=$jdkdir/bin/javac
fi 

JAVAINCLUDES="-I$jdkdir/include -I$jdkdir/include/solaris -I$jdkdir/include/genunix"
AC_SUBST(JAVASTUBS)
AC_SUBST(JAVAINCLUDES)
AC_SUBST(jdkdir)
])

