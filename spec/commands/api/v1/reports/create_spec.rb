require 'rails_helper'

RSpec.describe Api::V1::Reports::Create do
  let(:name) { 'report_name' }
  let(:file) { File.open(Rails.root.join('spec', 'mocks', file_name), 'r') }
  let(:current_user) { create(:user) }

  subject(:command) { described_class.new(name: name, file: file, current_user: current_user) }

  context 'when the file format is invalid' do
    let(:file_name) { 'dog.png' }

    it 'fails' do
      expect(command.call.success?).to be false
    end

    it 'returns an error message in the response' do
      expect(command.call.result[:message]).to eq('Invalid file type.')
    end
  end

  context 'when the file size is invalid' do
    let(:file_name) { 'test_data_2.csv' }

    before do
      allow(File).to receive(:size).and_return(Api::V1::Reports::Create::MAX_SIZE + 1)
    end

    it 'fails' do
      expect(command.call.success?).to be false
    end

    it 'returns an error message in the response' do
      expect(command.call.result[:message]).to eq('Invalid file size.')
    end
  end

  context 'when the total number of keywords is invalid' do
    let(:file_name) { 'test_data_0.csv' }

    it 'fails' do
      expect(command.call.success?).to be false
    end

    it 'returns an error message in the response' do
      expect(command.call.result[:message]).to eq('Invalid file content.')
    end
  end

  context 'when the content of file is invalid' do
    let(:file_name) { 'test_data_quotes.csv' }

    it 'fails' do
      expect(command.call.success?).to be false
    end

    it 'returns an error message in the response' do
      expect(command.call.result[:message]).to eq('Invalid file content.')
    end
  end

  context 'when the file is valid' do
    let(:file_name) { 'test_data_2.csv' }

    it 'succeeds' do
      expect(command.call.success?).to be true
    end

    it 'creates a new report with the correct name and user' do
      expect{ command.call }.to change{ Report.count }.by(1)
      expect(Report.last.name).to eq(name)
      expect(Report.last.user).to eq(current_user)
    end

    it 'creates the correct number of keywords' do
      expect{ command.call }.to change{ Keyword.count }.by(2)
    end

    it 'returns the report id in the response data' do
      expect(command.call.result[:data][:id]).to eq(Report.last.id)
    end

    it 'enqueues a background job to fetch keywords' do
      expect {
        command.call
      }.to change(FetchKeywordsWorker.jobs, :size).by(1)
    end
  end
end
