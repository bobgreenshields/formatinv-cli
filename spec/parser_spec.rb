require_relative '../lib/parser'

include FormatInv

describe Parser do
	let(:parser) { Parser.new }

	describe '#check_enough_args' do
		context 'with less than 2 args' do
			let(:args) { ['filename'] }
			it 'calls #exit_not_enough_args' do
				expect(parser).to receive(:exit_not_enough_args)
				parser.check_enough_args(args)
			end
		end
		context 'with too many args' do
			let(:args) { ['1', '2', '3'] }
			it 'calls #exit_too_many_args' do
				expect(parser).to receive(:exit_too_many_args)
				parser.check_enough_args(args)
			end
		end
		context 'with 2 args' do
			let(:args) { ['1', '2'] }
			it 'does not cause an exit' do
				expect(parser).not_to receive(:exit_not_enough_args)
				expect(parser).not_to receive(:exit_too_many_args)
				parser.check_enough_args(args)
			end
		end
	end
	describe '#file?' do
		context 'when a file exists' do
			let(:path) { 'spec/test1.csv' }
			it 'returns true' do
				expect(parser.file?(path)).to be_truthy
			end
		end
		context 'when a file does not exist' do
			let(:path) { 'spec/not_exist.csv' }
			it 'returns false' do
				expect(parser.file?(path)).to be_falsey
			end
		end
	end
	describe '#directory?' do
		context "when the directory exists but the file doesn't" do
			let(:path) { 'spec/no_file.csv' }
			it 'returns true' do
				expect(parser.directory?(path)).to be_truthy
			end
		end
		context "when the directory does not exist" do
			let(:path) { 'no_dir/no_file.csv' }
			it 'returns false' do
				expect(parser.directory?(path)).to be_falsey
			end
		end
	end
	describe '#csv?' do
		context 'with a .csv file' do
			it 'returns true' do
				expect(parser.csv?('spec/test1.csv')).to be_truthy
			end
		end
		context 'with a .CSV file' do
			it 'returns true' do
				expect(parser.csv?('spec/test1.CSV')).to be_truthy
			end
		end
		context 'with a .txt file' do
			it 'returns false' do
				expect(parser.csv?('spec/test1.txt')).to be_falsey
			end
		end
	end

	
end
