require_relative '../lib/app'
require_relative '../lib/details'

include FormatInv

describe App do
	let(:input) {  Pathname.new("./spec/test1.csv").expand_path }
	let(:output) {  Pathname.new("./spec/output.csv").expand_path }
	let(:args) { { input: input, output: output } }
	let(:app) { App.new(args) }

	describe '#read_csv' do
		it 'returns a CSV::Table' do
			result = app.read_csv
			expect(result).to be_a(CSV::Table)
			# result.each { |row| puts row["Ref"] }
			# result.each { |row| puts row["Detail"] }
		end
		it 'has the correct 1st row' do
			result = app.read_csv
			expect(result[0]["Date"]).to eql("15 Feb 23")
			expect(result[0]["Detail"]).to eql("This detail")
			expect(result[0]["Ref"]).to eql("GwydrCres44")
			expect(result[0]["VatQ"]).to eql("23Q1")
		end
	end

	describe '#check_headers' do
		context 'with correct headers' do
			let(:csv) do
				CSV.parse("Ref,Detail\nsth12,sofa\ngwydr,new taps", headers: true)
			end
			it 'does not call exit_missing_header' do
				expect(app).not_to receive(:exit_missing_header)
				app.check_headers(csv)
			end
			it 'returns the csv' do
				expect(app.check_headers(csv)).to eql(csv)
			end
		end
		context 'with Ref missing' do
			let(:csv) do
				CSV.parse("VAT,Detail\nsth12,sofa\ngwydr,new taps", headers: true)
			end
			it 'calls exit_missing_header with Ref' do
				expect(app).to receive(:exit_missing_header).with("Ref")
				app.check_headers(csv)
			end
		end
		context 'with Detail missing' do
			let(:csv) do
				CSV.parse("Ref,VAT\nsth12,sofa\ngwydr,new taps", headers: true)
			end
			it 'calls exit_missing_header with Detail' do
				expect(app).to receive(:exit_missing_header).with("Detail")
				app.check_headers(csv)
			end

		end
	end

	describe '#load_details' do
		let(:details) { app.load_details(app.read_csv) }
		it 'returns a details object' do
			expect(details).to be_a(Details)
		end
	end
	# describe 'test csv' do
	# 	let(:my_csv) do
	# 		csv_str = "Ref,Detail\nsth12,sofa\ngwydr,new taps"
	# 		result = CSV.parse(csv_str, headers: true)
	# 	end
	# 	it 'returns a CSV::Table' do
	# 		expect(my_csv).to be_a(CSV::Table)
	# 	end
	# 	it 'has correct headers' do
	# 		expect(my_csv.headers).to eql(["Ref", "Detail"])
	# 	end
	# end
	
	describe '#write_csv' do
		# let(:details) do
		# 	result = Details.new
		# 	result.add('sth12', 'add pvr')
		# 	result.add('sth12', 'new remote')
		# 	result.add('sth12', 'paint')
		# 	result.add('ayles', '1')
		# 	result.add('ayles', '2')
		# 	result.add('ayles', '3')
		# 	result.add('ayles', '4')
		# 	result.add('ayles', '5')
		# 	result	
		# end
		let(:details) { app.load_details(app.read_csv) }
		it 'writes a file' do
			app.write_csv(details)
			expect(output.exist?).to be_truthy
		end
	end
end
