# Comment-Wrapper
A Script that word wraps comments in ruby files 

# Instructions
Copy the files you want to word wrap in the the Originals Folder. Then run the ruby script, enter the name and extention, eg test.rb.
Dont add a file path. The program will make a new file in the wrapped directory.

To change the number of characters in each line or to change the file name of the putput file, edit the 'USER VARIABLES' in the script.

It wont affect ruby code. It only alters lines that begin with a '#' it also wont change indented comments.

# Known issues

The program only sorts line by line, so if you have a multiline comment you want to wrap, you may get wierd results. This could be fixed
by looping the file and checking ifthe next line is a comment as well then formminging the two lines together.

