module Api
  module V1
    class KeywordsController < BaseController
      def get_html_source
        cmd = Api::V1::Keywords::GetHtmlSource.call(permitted_params.merge(current_user: current_user))

        if cmd.success?
          render html: cmd.result[:data][:html_string].html_safe
        else
          render json: cmd.result, status: :unprocessable_entity
        end
      end

      private

      def permitted_params
        params.permit!
      end
    end
  end
end
