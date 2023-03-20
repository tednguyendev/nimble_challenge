require 'rails_helper'

RSpec.describe Api::V1::Reports::List, type: :model do
  let(:params) do
    {}
  end

  let(:user) { create(:user) }

  let(:report1) { create(:report, name: 'b', user: user, status: Report::PENDING, percentage: 0) }
  let(:report2) { create(:report, name: 'a', user: user, status: Report::PENDING, percentage: 10) }
  let(:report3) { create(:report, name: 'c', user: user, status: Report::SUCCESS, percentage: 100) }

  let!(:keyword1) { create(:keyword, value: 'a', report: report1) }
  let!(:keyword2) { create(:keyword, value: 'b', report: report2) }
  let!(:keyword3) { create(:keyword, value: 'c', report: report3) }

  let(:report1_id) { report1.id }
  let(:report2_id) { report2.id }
  let(:report3_id) { report3.id }

  describe '#call' do
    context 'valid params?' do
      it 'success' do
        cmd = described_class.call(params.merge(current_user: user))

        expect(cmd.success?).to be(true)
        expect(cmd.result[:data][:records].first).to include(
          :id,
          :name
        )
      end
    end
  end

  describe '#pagination' do
    describe '#per_page' do
      let(:params) do
        {
          page: 1,
          per_page: 2,
        }
      end

      it 'success' do
        cmd = described_class.call(params.merge(current_user: user))

        expect(cmd.result[:data][:records].pluck(:id)).to eq([report3_id, report2_id])
      end
    end

    describe '#page' do
      let(:params) do
        {
          page: 2,
          per_page: 1,
        }
      end

      it 'success' do
        cmd = described_class.call(params.merge(current_user: user))

        expect(cmd.result[:data][:records].pluck(:id)).to eq([report2_id])
      end
    end

    describe '#page #per_page' do
      let(:params) do
        {
          page: 2,
          per_page: 2,
        }
      end

      it 'success' do
        cmd = described_class.call(params.merge(current_user: user))

        expect(cmd.result[:data][:records].pluck(:id)).to eq([report1_id])
      end
    end
  end

  describe '#filter' do
    context 'filter_by_name_or_keywords' do
      let(:params) do
        {
          keyword: 'a'
        }
      end

      it 'returns correct reports' do
        cmd = described_class.call(params.merge(current_user: user))

        expect(cmd.result[:data][:records].pluck(:id)).to eq([report2_id, report1_id])
      end
    end
  end

  describe '#order' do
    context 'order_by_name_descending' do
      let(:params) do
        {
          order_by: 'name_descending'
        }
      end

      it 'returns correct report' do
        cmd = described_class.call(params.merge(current_user: user))

        expect(cmd.result[:data][:records].pluck(:id)).to eq([report3_id, report1_id, report2_id])
      end
    end

    context 'order_by_name_ascending' do
      let(:params) do
        {
          order_by: 'name_ascending'
        }
      end

      it 'returns correct report' do
        cmd = described_class.call(params.merge(current_user: user))

        expect(cmd.result[:data][:records].pluck(:id)).to eq([report2_id, report1_id, report3_id])
      end
    end

    context 'order_by_created_at_descending' do
      let(:params) do
        {
          order_by: 'created_at_descending'
        }
      end

      it 'returns correct report' do
        cmd = described_class.call(params.merge(current_user: user))

        expect(cmd.result[:data][:records].pluck(:id)).to eq([report3_id, report2_id, report1_id])
      end
    end

    context 'order_by_created_at_ascending' do
      let(:params) do
        {
          order_by: 'created_at_ascending'
        }
      end

      it 'returns correct report' do
        cmd = described_class.call(params.merge(current_user: user))

        expect(cmd.result[:data][:records].pluck(:id)).to eq([report1_id, report2_id, report3_id])
      end
    end

    context 'order_by_status_descending' do
      let(:params) do
        {
          order_by: 'status_descending'
        }
      end

      it 'returns correct report' do
        cmd = described_class.call(params.merge(current_user: user))

        expect(cmd.result[:data][:records].pluck(:id)).to eq([report3_id, report1_id, report2_id])
      end
    end

    context 'order_by_status_ascending' do
      let(:params) do
        {
          order_by: 'status_ascending'
        }
      end

      it 'returns correct report' do
        cmd = described_class.call(params.merge(current_user: user))

        expect(cmd.result[:data][:records].pluck(:id)).to eq([report1_id, report2_id, report3_id])
      end
    end

    context 'order_by_percentage_descending' do
      let(:params) do
        {
          order_by: 'percentage_descending'
        }
      end

      it 'returns correct report' do
        cmd = described_class.call(params.merge(current_user: user))

        expect(cmd.result[:data][:records].pluck(:id)).to eq([report3_id, report2_id, report1_id])
      end
    end

    context 'order_by_percentage_ascending' do
      let(:params) do
        {
          order_by: 'percentage_ascending'
        }
      end

      it 'returns correct report' do
        cmd = described_class.call(params.merge(current_user: user))

        expect(cmd.result[:data][:records].pluck(:id)).to eq([report1_id, report2_id, report3_id])
      end
    end
  end
end
