require 'csv'
require_relative '../lib/details.rb'

include FormatInv

describe Details do
	let(:details) { Details.new }
	
	describe '#add' do
		context 'when it has no existing ref' do
			it 'adds the detail after the ref' do
				details.add('sth12', 'add pvr')
				expect(details['sth12']).to eql(['sth12', 'add pvr'])
			end
		end
		context 'when it has an existing ref and details' do
			it 'appends the new detail to the array' do
				details.add('sth12', 'add pvr')
				details.add('sth12', 'new remote')
				details.add('sth12', 'paint')
				expect(details['sth12']).to eql(['sth12', 'add pvr', 'new remote', 'paint'])
			end
		end
	end

	describe '#to_a' do
		let(:populated) do
			details.add('sth12', 'add pvr')
			details.add('sth12', 'new remote')
			details.add('sth12', 'paint')
			details.add('ayles', 'new taps')
			details.add('sth08', 'sofa')
			details.add('sth08', 'cleaning products')
			details
		end

		it 'returns an array' do
			expect(populated.to_a).to be_a Array
		end
		it 'returns an array of the correct length' do
			expect(populated.to_a.length).to eql(3)
		end
		it 'orders the keys' do
			expect(populated.to_a[0][0]).to eql("ayles")
			expect(populated.to_a[1][0]).to eql("sth08")
			expect(populated.to_a[2][0]).to eql("sth12")
		end
		it 'populates the sub arrays' do
			expect(populated.to_a[0].length).to eql(2)
			expect(populated.to_a[1].length).to eql(3)
			expect(populated.to_a[2].length).to eql(4)
		end
	end

end
