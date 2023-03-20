module Api
  module V1
    module Keywords
      class GetHtmlSource
        prepend SimpleCommand
        prepend SimpleResponse

        def initialize(opts = {})
          @id = opts[:id]
          @current_user = opts[:current_user]
        end

        def call
          return response(message: 'Keyword not exists.') if keyword_not_exists?

          response({
            data: {
              html_string: keyword.html_string
            }
          })
        end

        private

        attr_reader :id, :current_user

        def keyword_not_exists?
          keyword.nil?
        end

        def keyword
          @keyword = Keyword.where(user: current_user, status: Keyword::SUCCESS).find_by_id(id)
        end
      end
    end
  end
end
