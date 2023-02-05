require 'optparse'
require 'pathname'
require_relative 'error_codes'

module FormatInv
	class Parser
		def initialize
			@args = {}
		end

		def opt_parser
			@opt_parser ||= OptionParser.new do | opts |
				opts.banner = 'Usage: formatinv input_csv_file output_csv_file'
				opts.on '-h', '--help', 'Prints this help' do puts opts; exit end
			end
		end

		def call(argv)
			args_arr = opt_parser.parse(argv)
			check_enough_args(args_arr)
			check_valid_path(args_arr[0])
			check_valid_dir(args_arr[1])
			@args[:input] = Pathname.new(args_arr[0]).expand_path
			@args[:output] = Pathname.new(args_arr[1]).expand_path
			check_is_csv(:input)
			check_is_csv(:output)
			@args
		end

		def check_enough_args(args_arr)
			exit_not_enough_args if args_arr.length < 2
			exit_too_many_args if args_arr.length > 2
		end

		def check_valid_path(file_str)
			exit_input_file_not_exist(file_str) unless file?(file_str)
		end

		def check_valid_dir(file_str)
			exit_output_file_dir_not_exist(file_str) unless directory?(file_str)
		end

		def check_is_csv(direction)
			exit_not_csv(direction) unless csv?(@args[direction])
		end

		def file?(file_str)
			Pathname.new(file_str).file?
		end

		def directory?(file_str)
			Pathname.new(file_str).expand_path.dirname.directory?
		end

		def csv?(file_str)
			Pathname.new(file_str).extname.downcase == ".csv"
		end

		def exit_not_enough_args
			STDERR.puts 'formatinv needs two arguments'
			STDERR.puts 'The first should be the input csv file'
			STDERR.puts 'The second should be the output csv file'
			STDERR.puts 'It was called with too few arguments'
			exit(NOT_ENOUGH_ARGS)
		end
		
		def exit_too_many_args
			STDERR.puts 'formatinv needs two arguments'
			STDERR.puts 'The first should be the input csv file'
			STDERR.puts 'The second should be the output csv file'
			STDERR.puts 'It was called with too many arguments'
			exit(TOO_MANY_ARGS)
		end

		def exit_not_csv(direction)
			STDERR.puts 'A csv file needs to end in .csv'
			STDERR.puts "This file doesn't: #{@args[direction]}"
			exit(NOT_A_CSV)
		end

		def exit_input_file_not_exist(file_str)
			STDERR.puts 'The input file'
			STDERR.puts file_str
			STDERR.puts 'does not exist'
			exit(INPUT_FILE_NOT_EXIST)
		end

		def exit_output_file_dir_not_exist(file_str)
			STDERR.puts 'The directory for the output file'
			STDERR.puts file_str
			STDERR.puts 'does not exist'
			exit(OUTPUT_FILE_DIR_NOT_EXIST)
		end
	end
end
