require 'pathname'
require 'csv'
require_relative 'details'
require_relative 'error_codes'

module FormatInv

	class App
		REF_STR = "Ref"
		DETAIL_STR = "Detail"

		def initialize(args)
			@args = args
			@details = Details.new
		end

		def call
			csv = check_headers(read_csv)
			write_csv(load_details(csv))
		end

		def read_csv
			CSV.parse(File.read(@args[:input]), headers: true)
		end

		def check_headers(csv)
			exit_missing_header(REF_STR) unless csv.headers.include? REF_STR
			exit_missing_header(DETAIL_STR) unless csv.headers.include? DETAIL_STR
			csv
		end

		def exit_missing_header(header)
			STDERR.puts "The input CSV file was missing the header: #{header}"
			exit(HEADER_MISSING)
		end

		def load_details(csv)
			csv.each do |row|
				@details.add(row[REF_STR], row[DETAIL_STR])
			end
			@details
		end

		def write_csv(details)
			CSV.open(@args[:output],'w') do |csv|
				details.to_a.each do |row|
					csv << row
				end
		  end
		end
	end
end
