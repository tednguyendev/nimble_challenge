MAX_SIZE = 10.megabytes
MIN_KEYWORDS = 1
MAX_KEYWORDS = 100

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
          return response(message: 'Invalid file type.') if invalid_file_format
          return response(message: 'Invalid file size.') if invalid_file_size
          return response(message: 'Invalid file content.') if invalid_total_keywords

          report = nil

          ActiveRecord::Base.transaction do
            report = Report.create(
              user: current_user,
              name: name
            )
            keywords.each do |keyword|
              Keyword.create(
                value: keyword,
                report: report,
              )
            end
          end

          FetchKeywordsWorker.perform_async(report.id)

          response(
            data: {
              id: report.id
            }
          )
        end

        private

        def invalid_file_format
          File.extname(file.path).downcase != ".csv"
        end

        def invalid_file_size
          File.size(file.path) > MAX_SIZE
        end

        def invalid_total_keywords
          keywords.length < MIN_KEYWORDS || keywords.length > MAX_KEYWORDS
        end

        def keywords
          @keywords ||= CSV.parse(file.read).flatten.uniq
        rescue
          @keywords ||= []
        end

        attr_reader :name, :file, :current_user
      end
    end
  end
end
