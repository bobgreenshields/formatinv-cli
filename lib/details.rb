module FormatInv
	class Details

		def initialize
			@details_hash = Hash.new { |hash, key| hash[key] = [key.to_s] }
		end

		def add(ref, detail)
			@details_hash[ref] << detail
			self
		end

		def [](ref)
			@details_hash.has_key?(ref) ? @details_hash[ref] : []
		end

		def to_a
			keys = @details_hash.keys
			sorted_keys = keys.sort
			result = []
			sorted_keys.each { |key| result << @details_hash[key] }
			result
		end

			
	end
	
end
