# File: word_wrapper.rb
# Date: 23/02/19
# Author: Edward Deam
# Comments: Script to word wrap .rb file comments. Takes the name of a ruby
# file and returns a new file with user defied prefix or suffix with no comment
# line longer than 80 characters. Does not alter any code that is not a comment
# (# prefix).

###############################################################################
# USER VARIABLES
# These variables can be changed without breaking the program.
#
# The max number of characters you want in a line. Must be an integer
MAX_CHAR_PER_LINE = 80
# The Prefix of the new filename eg.(file.rb -> ww_file.rb)
# Best not to use special characters. Leave blank for none.
FILE_PREFIX = ''.freeze
# The Suffix of the new filename eg.(file.rb -> file_ww.rb)
# Best not to use special characters. Leave blank for none.
FILE_SUFFIX = ''.freeze
###############################################################################

# Wrapper Method that calls methods in the order needed.
def main(max_char, prefix, suffix)
  # Variable Definitions
  # Check if USER VARIABLES are valid.
  raise ArgumentError, 'Invaild user variables.' unless check_user_variables

  # Get the name of the file that will be word wrapped.
  file_name = ask_input_file_name
  # Concatenate the folder name and file name to give a path so that the
  # file can be searched for later.
  file_path = 'Original/' + file_name
  original_arr = read_input_file(file_path)
  # Check the original_arr and make sure that no comment line is longer than
  # the max specified
  wordwrapped_arr = word_wrap(original_arr, max_char)
  # Create a path for the output file to go
  output_path = create_output_path('Wrapped/', file_name, prefix, suffix)
  # Write the formatted array to the output file
  write_formatted_file(wordwrapped_arr, output_path)
end

def ask_input_file_name
  print 'Enter File Name With Extention: '
  gets.strip
end

def no_file_error(path)
  # If the file does not exist exit the program and give the user some
  # solutions to fix the problem.
  puts "ERROR: The File at '~/#{path}' can not be found."
  puts 'Check that the file name is spelled correctly.'
  puts 'Check that the file has the correct extention (*.rb).'
  puts "Check that the file is in the folder 'WordWrapper/Original/'."
  exit
end

def read_input_file(filepath)
  # Check that the file_path is valid, if not the program will exit.
  no_file_error(filepath) unless File.exist?(filepath)
  # Array to store the lines of the file
  lines = []
  # Opens the file it the path and loops ecah line
  File.foreach(filepath) do |line|
    # Add each line from the file to the array
    lines.push(line)
  end
  lines
end

def word_wrap(original_array, max_line_length)
  # Array of formated lines
  wrapped_lines = []
  # Loop the lines from the original file
  original_array.each do |line|
    # check if the line needs to be formatted
    if line_needs_formating?(line, max_line_length)
      # Format the line and get returned an array of short lines
      new_lines = format_line(line, max_line_length)
      # loop these new lines and add them to the formatted array
      new_lines.each { |wrapped_line| wrapped_lines.push(wrapped_line) }
    else
      # If the line doesn't need or cant be formatted just push it
      wrapped_lines.push(line)
    end
  end
  wrapped_lines
end

def line_needs_formating?(line, max_line_length)
  # Check to see if the line is a comment
  if line[0] == '#'
    # Check the length of the line
    false if max_line_length > line.length
    # if the line is too long then it need formatting
    true
  else
    # This only formats comments if there is no '#' return
    false
  end
end

def format_line(line, max_line_length)
  # Array of formated lines
  new_lines = []
  # Where the words will be added to make the new comment
  formatted_line = '#'
  # Split the line up into an array of individual words
  words = line.split(' ')
  # Remove the # at the beggining of the array
  words.shift
  # Loop each word and add it to the formatted_line string
  words.each do |word|
    if formatted_line.length + word.length + 1 <= max_line_length
      # If the line + the new word will be less that the max allowed
      # length add the word to the string. The + 1 is to account for the
      # fact that a space is added between words.
      formatted_line += ' ' + word
    else
      # If the line + word will be too long, push that line to the new
      # lines array and start a new line.
      new_lines.push(formatted_line)
      # line will be overridden here, reseting it
      formatted_line = '# ' + word
    end
    # When the loop reaches the final word, push the line to the array.
    new_lines.push(formatted_line) if word == words.last
  end
  new_lines
end

def create_output_path(folder, filename, prefix, suffix)
  # get the index of the '.' to find the file extention and save
  extention = filename.slice(filename.index('.'), filename.length)
  # remove the extention from the file so the pre/suffix's can be added
  filename.delete!(extention)
  # Concatenate the new file name string
  output_file_name = prefix + filename + suffix + extention
  # Concatenate the output path
  path = folder + output_file_name
  path
end

def write_formatted_file(word_wrapped_array, filepath)
  # Create a new file and open it. 'w' is flag for  a new, empty, write file
  File.open(filepath, 'w') do |file|
    # Loop the formatted array
    word_wrapped_array.each do |line|
      # Print each new line to the file
      file.puts(line)
    end
  end
  puts 'Formatting Succeded.'
end

def check_user_variables
  # Check that user variables are valid
  return false unless MAX_CHAR_PER_LINE.is_a?(Integer)
  return false if MAX_CHAR_PER_LINE <= 11
  return false unless FILE_PREFIX.is_a?(String)
  return false unless FILE_SUFFIX.is_a?(String)
end

# helper method to 'puts' data to the console, just makes it easier to find
# and remove calls to it once its no longer needed.
def debug_log(arg)
  print('DEBUG: ')
  puts arg
end

# boolean to keep the program running
is_running = true
# Appliation Loop
while is_running
  # Clear the terminal
  system 'clear'
  # Call the main method to run the program
  main(MAX_CHAR_PER_LINE, FILE_PREFIX, FILE_SUFFIX)
  # Ask the user if they need to convert more files
  puts "Enter 'y' to convert another file."
  print 'Enter any other key to quit: '
  input = gets.chomp
  # If input is not 'y' end the loop to finish the program
  is_running = (input != 'y')
end
