#! /usr/bin/env bash

# This script generates an expected output file or expected error
# file (whichever is appropriate) for a specified input file.

if [ $# -eq 0 ]; then
  echo "No"
  exit 1
fi

testname=$(basename $1 .in)

expected_output_file=expected_output/$testname.out
expected_error_file=expected_error/$testname.out

test_data=""
if [ -f "data/${testname}.in" ]; then
  test_data=$(<data/${testname}.in)
fi

(echo "$test_data" | $ASSIGN03_DIR/compiler -s $1 | egrep -i -v "^Debug:") > $expected_output_file 2> $expected_error_file

if [ -f $expected_output_file ] && [ ! -s $expected_output_file ]; then
  # expected output file is empty, delete it
  rm $expected_output_file
fi

if [ -f $expected_error_file ] && [ ! -s $expected_error_file ]; then
  # expected error file is empty, delete it
  rm $expected_error_file
fi

# If expected error file was produced, delete the expected output file
# (since it's possible that some valid output was produced before the
# error was reported)
if [ -f $expected_error_file ]; then
  echo "Expected error file was produced, deleting expected output file"
  rm -f $expected_output_file
fi
