require 'rails_helper'

RSpec.describe Report, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:keywords).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_length_of(:name).is_at_most(255) }
  end

  describe 'scopes' do
    describe 'order_by_name_descending' do
      it 'orders the reports by name in descending order' do
        report1 = create(:report, name: 'Report B')
        report2 = create(:report, name: 'Report A')
        expect(Report.order_by_name_descending).to eq([report1, report2])
      end
    end

    describe 'order_by_name_ascending' do
      it 'orders the reports by name in ascending order' do
        report1 = create(:report, name: 'Report B')
        report2 = create(:report, name: 'Report A')
        expect(Report.order_by_name_ascending).to eq([report2, report1])
      end
    end

    describe 'order_by_created_at_descending' do
      it 'orders the reports by creation time in descending order' do
        report1 = create(:report)
        report2 = create(:report)
        expect(Report.order_by_created_at_descending).to eq([report2, report1])
      end
    end

    describe 'order_by_created_at_ascending' do
      it 'orders the reports by creation time in ascending order' do
        report1 = create(:report)
        report2 = create(:report)
        expect(Report.order_by_created_at_ascending).to eq([report1, report2])
      end
    end

    describe 'order_by_status_descending' do
      it 'orders the reports by status in descending order' do
        report1 = create(:report, status: :success)
        report2 = create(:report, status: :pending)
        expect(Report.order_by_status_descending).to eq([report1, report2])
      end
    end

    describe 'order_by_status_ascending' do
      it 'orders the reports by status in ascending order' do
        report1 = create(:report, status: :success)
        report2 = create(:report, status: :pending)
        expect(Report.order_by_status_ascending).to eq([report2, report1])
      end
    end

    describe 'order_by_percentage_descending' do
      it 'orders the reports by percentage in descending order' do
        report1 = create(:report, percentage: 80)
        report2 = create(:report, percentage: 90)
        expect(Report.order_by_percentage_descending).to eq([report2, report1])
      end
    end

    describe 'order_by_percentage_ascending' do
      it 'orders the reports by percentage in ascending order' do
        report1 = create(:report, percentage: 80)
        report2 = create(:report, percentage: 90)
        expect(Report.order_by_percentage_ascending).to eq([report1, report2])
      end
    end
  end

  describe 'callbacks' do
    describe 'set_name' do
      context 'no name is provided' do
        it 'sets the name' do
          Timecop.freeze
          report = create(:report)
          expect(report.name).to eq("Report at #{Time.current.strftime('%Y-%m-%d %H:%M:%S')}")
        end
      end

      context 'name is provided' do
        it 'does not set the name' do
          report = create(:report, name: 'Custom Name')
          expect(report.name).to eq('Custom Name')
        end
      end
    end

    describe 'set_status' do
      context 'percentage is 100' do
        it 'sets the status to :success' do
          report = create(:report, status: :pending)
          report.update(percentage: 100)
          expect(report.status).to eq('success')
        end
      end

      context 'percentage is not 100' do
        it 'does not set the status to :success' do
          report = create(:report, status: :pending)
          report.update(percentage: 90)
          expect(report.status).to eq('pending')
        end
      end
    end
  end
end
