# ftp_test(int_cmd, file1 [, file2] ) -> obj
#  Uses the integer <i>aCmd</i> to perform various tests on
#  <i>file1</i> (first table below) or on <i>file1</i> and
#  <i>file2</i> (second table).
#
#  File tests on a single file:
#
#    Test   Returns   Meaning
#    "A"  | Time    | Last access time for file1
#    "b"  | boolean | True if file1 is a block device
#    "c"  | boolean | True if file1 is a character device
#    "C"  | Time    | Last change time for file1
#    "qos"  | boolean | True if file1 exists and is a directory
#    "e"  | boolean | True if file1 exists
#    "f"  | boolean | True if file1 exists and is a regular file
#    "g"  | boolean | True if file1 has the \CF{setgid} bit
#         |         | set (false under NT)
#    "G"  | boolean | True if file1 exists and has a group
#         |         | ownership equal to the caller's group
#    "k"  | boolean | True if file1 exists and has the sticky bit set
#    "l"  | boolean | True if file1 exists and is a symbolic link
#    "M"  | Time    | Last modification time for file1
#    "o"  | boolean | True if file1 exists and is owned by
#         |         | the caller's effective uid
#    "O"  | boolean | True if file1 exists and is owned by
#         |         | the caller's real uid
#    "p"  | boolean | True if file1 exists and is a fifo
#    "r"  | boolean | True if file1 is readable by the effective
#         |         | uid/gid of the caller
#    "R"  | boolean | True if file is readable by the real
#         |         | uid/gid of the caller
#    "s"  | int/nil | If file1 has nonzero size, return the size,
#         |         | otherwise return nil
#    "S"  | boolean | True if file1 exists and is a socket
#    "u"  | boolean | True if file1 has the setuid bit set
#    "w"  | boolean | True if file1 exists and is writable by
#         |         | the effective uid/gid
#    "W"  | boolean | True if file1 exists and is writable by
#         |         | the real uid/gid
#    "x"  | boolean | True if file1 exists and is executable by
#         |         | the effective uid/gid
#    "X"  | boolean | True if file1 exists and is executable by
#         |         | the real uid/gid
#    "z"  | boolean | True if file1 exists and has a zero length
#
# Tests that take two files:
#
#    "-"  | boolean | True if file1 and file2 are identical
#    "="  | boolean | True if the modification times of file1
#         |         | and file2 are equal
#    "<"  | boolean | True if the modification time of file1
#         |         | is prior to that of file2
#    ">"  | boolean | True if the modification time of file1
#         |         | is after that of file2
p test("A",'kernel_test')
p test("-",'kernel_test',"kerner_test")

t = :tt
p "#{t}_aa"