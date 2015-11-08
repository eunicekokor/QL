#!/bin/sh

# Adapted from Prof. Edwards' test script for MicroC.

# Time limit for operations
ulimit -t 100

globalerror=0
globallog=run_tests.log
rm -f $globallog
error=0

SignalError() {
  if [ $error -eq 0 ] ; then
    echo "FAILED"
    error=1
  fi
  echo "  $1"
}

# Compare <outfile> <reffile> <difffile>
# Compares the outfile with reffile.  Differences, if any, written to difffile
Compare() {
  generatedfiles="$generatedfiles $3"
  echo diff -b $1 $2 ">" $3 1>&2
  diff -b "$1" "$2" > "$3" 2>&1 || {
    SignalError "$1 differs"
    echo "FAILED $1 differs from $2" 1>&2
  }
}

Run() {
  echo $* 1>&2
  eval $* || {
    SignalError "$1 failed on $*"
    return 1
  }
}

Check() {
  error=0

  # strip ".ql" off filename
  basename=`echo $1 | sed 's/.ql//'`

  echo -n "$basename..."

  echo 1>&2
  echo "###### Testing $basename" 1>&2

  generatedfiles="$generatedfiles ${basename}.i.out" &&
  Run "menhir" "-v" "<" $1 ">" ${basename}.i.out &&
  Compare ${basename}.i.out ${basename}.out ${basename}.i.diff

  # The following lines will make more sense when we can actually run QL programs

  # generatedfiles="$generatedfiles ${basename}.i.out" &&
  # Run "../ql" "-i" "<" $1 ">" ${basename}.i.out &&
  # Compare ${basename}.i.out ${reffile}.out ${basename}.i.diff

  # generatedfiles="$generatedfiles ${basename}.c.out" &&
  # Run "../ql" "-c" "<" $1 ">" ${basename}.c.out &&
  # Compare ${basename}.c.out ${reffile}.out ${basename}.c.diff

  # Report the status and clean up the generated files

  if [ $error -eq 0 ] ; then
    echo "OK"
    echo "###### SUCCESS" 1>&2
  else
    echo "###### FAILED" 1>&2
    globalerror=$error
  fi
}

shift `expr $OPTIND - 1`

if [ $# -ge 1 ]
then
  files=$@
else
  files="tests/test-*.mc"
fi

for file in $files
do
  Check $file 2>> $globallog
done

exit $globalerror
