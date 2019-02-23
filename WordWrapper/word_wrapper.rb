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
FILE_PREFIX = 'ww_'
# The Suffix of the new filename eg.(file.rb -> file_ww.rb)
# Best not to use special characters. Leave blank for none.
FILE_SUFFIX = ''
###############################################################################

# Wrapper Function that calls functions in the order we need them.
def main (max_char, prefix, suffix)
    # Variable Definitions
    input_folder = 'Original/'  # Folder of original files
    output_folder = 'Wrapped/'  # Folder of processed files
    file_name = ''              # The name of the file (test.rb)
    file_path = ''              # The path of the file (folder/test.rb)
    output_path = ''            # The path of the output file
    original_arr = []           # The lines of the original file
    wordwrapped_arr = []        # The formatxted file lines
    # Check if USER VARIABLES are valid.
    check_user_variables()
    # Get the name of the file that will be word wrapped.
    file_name = get_input_file_name()
  #  debug_log(file_name)
    # Concatenate the folder name and file name to give a path so that the
    # file can be searched for later.
    file_path = input_folder + file_name
   # debug_log(file_path)
    # Check that the file_path is valid, if not the program will exit.
    check_input_file(file_path)
    # Now that the file path is vaild, read the file contents and save to
    # the array.
    original_arr = read_input_file(file_path)
 #   debug_log(original_arr)
    # Check the original_arr and make sure that no comment line is longer than
    # the max specified 
    wordwrapped_arr = word_wrap(original_arr, max_char)
  #  debug_log(wordwrapped_arr)
    # Create a path for the output file to go
    output_path = create_output_path(output_folder, file_name, prefix, suffix)
    # Write the formatted array to the output file
    write_formatted_file(wordwrapped_arr, output_path)
    puts("Formatting Succeded.")
end

def get_input_file_name ( )
    print("Enter File Name With Extention: ")
    name = gets().strip()
    return name
end

def check_input_file ( path )
    # Check if the file the user gave actually exists at the path
    if(File.exist?(path))
        return
    else
        # If the file does not exist exit the program and give the user some
        # solutions to fix the problem.
        puts("ERROR: The File at '~/#{path}' can not be found.")
        puts("Check that the file name is spelled correctly.")
        puts("Check that the file has the correct extention (*.rb).")
        puts("Check that the file is in the folder 'WordWrapper/Original/'.")
        exit()
    end
end

def read_input_file ( filepath )
    # Array to store the lines of the file
    lines = []
    # Opens the file it the path and loops ecah line
    File.foreach( filepath ) do | line |
        # Add each line from the file to the array
        lines.push(line)
    end
    return lines
end

def word_wrap (original_array, max_line_length)
    # Array of formated lines
    wrapped_lines = []
    # Loop the lines from the original file
    original_array.each do | line |
        # check if the line needs to be formatted
        if(line_needs_formating?(line, max_line_length))
            # Format the line and get returned an array of short lines
            new_lines = format_line(line, max_line_length)
            # loop these new lines and add them to the formatted array
            new_lines.each do | wrapped_line |
                wrapped_lines.push(wrapped_line)
            end
        else
            # If the line doesn't need or cant be formatted just push it
            wrapped_lines.push(line)
        end
    end
    return wrapped_lines  
end

def line_needs_formating? ( line, max_line_length )
    # Check to see if the line is a comment
    if(line[0] == '#') 
        # Check the length of the line
        if(line.length() < max_line_length)
            # If the line is less than the max allowed length there is no need 
             # to change it
            return false
        else
            # If the line is longer that the max length then it needs changing
            return true
        end
    else
    # This only formats comments if there is no '#' return
    return false
    end 
end

def format_line ( line, max_line_length )
    # Array of formated lines
    new_lines = [] 
    # Where the words will be added to make the new comment
    formatted_line = '#'   
    # Split the line up into an array of individual words
    words = line.split(' ')
    # Remove the # at the beggining of the array
    words.shift()
    # Loop each word and add it to the formatted_line string
    words.each do | word |    
        if((formatted_line.length() + word.length() ) + 1 <= max_line_length)
            # If the line + the new word will be less that te max allowed length
            # add the word to the string. The + 1 is to account for the space 
            # that is added between words.
            formatted_line += ' ' + word
        else
            # If the line + word will be too long, push that line to the new
            # lines array and start a new line. 
            new_lines.push(formatted_line)
            # line will be overridden here, reseting it
            formatted_line = '# ' + word
        end
        if(word == words.last())
            # When the loop reaches the final word, push the line to the array.
           new_lines.push(formatted_line)
        end
    end
    return new_lines
end

def create_output_path (folder, filename, prefix, suffix)
    # get the index of the '.' to find the file extention and save
    extention = filename.slice(filename.index('.'), filename.length())
    # remove the extention from the file so the pre/suffix's can be added
    filename.delete!(extention)
    # Concatenate the new file name string
    output_file_name = prefix + filename + suffix + extention
    # Concatenate the output path  
    path = folder + output_file_name
    return path
end

def write_formatted_file (word_wrapped_array, filepath)
    # Create a new file and open it 'w' for new empty write file
    File.open(filepath, 'w') do | file |
        # Loop the formatted array
        word_wrapped_array.each do | line |
            # Print each new line to the array
            file.puts(line)
        end
    end 
end

def check_user_variables()
    # Check that MAX_CHAR_PER_LINE is an integer
    if(!MAX_CHAR_PER_LINE.is_a?(Integer))
        abort("MAX_CHAR_PER_LINE must be an Integer it is currently a #{MAX_CHAR_PER_LINE.class()}")
    end
    # Check that FILE_PREFIX and FILE_SUFFIX are strings
    if(!FILE_PREFIX.is_a?(String))
        abort("FILE_PREFIX must be a String it is currently a #{FILE_PREFIX.class()}")
    end
    if(!FILE_SUFFIX.is_a?(String))
        abort("FILE_SUFFIX must be a String it is currently a #{FILE_SUFFIX.class()}")
    end
end

# helper function to 'puts' data to the console, just makes it easier to find
# and remove calls to it once its no longer needed.
def debug_log( arg )
    print('DEBUG: ')
    puts (arg)
end

# boolean to keep the program running
is_running = true
# Appliation Loop
while(is_running)
    # Clear the terminal
    system 'clear'
    # Call to main function to run the program
    main(MAX_CHAR_PER_LINE, FILE_PREFIX, FILE_SUFFIX)
    # Ask the user if they need to convert more files
    puts("Enter 'y' to convert another file.")
    print("Enter any other key to quit: ")
    input = gets.chomp()
    # If input is not 'y' end the loop to finish the program
    if(input == 'y')
        is_running = true
    else
        is_running = false
    end
end
