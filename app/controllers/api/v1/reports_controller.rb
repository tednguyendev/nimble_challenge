module Api
  module V1
    class ReportsController < BaseController
      def create
        cmd = Api::V1::Reports::Create.call({ file: permitted_params['file']}.merge(current_user: current_user))

        if cmd.success?
          render json: cmd.result, status: :ok
        else
          render json: cmd.result, status: :unprocessable_entity
        end
      end

      def list
        cmd = Api::V1::Reports::List.call(permitted_params.merge(current_user: current_user))

        if cmd.success?
          render json: cmd.result, status: :ok
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
