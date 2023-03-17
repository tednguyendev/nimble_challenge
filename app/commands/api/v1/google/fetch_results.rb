module Api
  module V1
    module Google
      class FetchResults
        prepend SimpleCommand
        prepend SimpleResponse

        def initialize(opts = {})
          @file = opts[:file]
          @current_user = opts[:current_user]
        end

        def call
          report = Report.create(user: current_user)

          ActiveRecord::Base.transaction do
            keywords.each do |keyword|
              Keyword.create(
                value: keyword,
                report: report,
              )
            end
          end

          # FetchData.perform_async(report.id)
          Api::V1::Google::FetchKeywords.call(report.id)
        end

        private

        def keywords
          @keywords ||= CSV.parse(file.read).flatten.uniq
        end

        attr_reader :file, :current_user
      end
    end
  end
end
