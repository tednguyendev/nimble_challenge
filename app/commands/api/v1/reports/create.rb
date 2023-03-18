module Api
  module V1
    module Reports
      class Create
        prepend SimpleCommand
        prepend SimpleResponse

        def initialize(opts = {})
          @name = opts[:name]
          @file = opts[:file]
          @current_user = opts[:current_user]
        end

        def call
          if keywords.blank?
            errors.add(:file, 'invalid')

            return response(
              message: 'Invalid file'
            )
          end

          report = Report.create(user: current_user, name: name)

          ActiveRecord::Base.transaction do
            keywords.each do |keyword|
              Keyword.create(
                value: keyword,
                report: report,
              )
            end
          end

          response(
            data: {
              id: report.id
            }
          )

          # FetchData.perform_async(report.id)
          # Api::V1::Google::FetchKeywords.call(report.id)
        end

        private

        def keywords
          @keywords ||= CSV.parse(file.read).flatten.uniq
        end

        attr_reader :name, :file, :current_user
      end
    end
  end
end
