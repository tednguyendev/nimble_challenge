module Api
  module V1
    class AuthenticateController < BaseController
      skip_before_action :authenticate_request!

      def sign_up
        cmd = Api::V1::Authenticate::SignUp.call(params)

        if cmd.success?
          render json: cmd.result, status: :ok
        else
          render json: cmd.result, status: :unprocessable_entity
        end
      end

      def verify_email
        cmd = Api::V1::Authenticate::VerifyEmail.call(params)

        if cmd.success?
          redirect_to("#{ENV['FRONT_END_ENDPOINT']}/sign-in?status=success")
        else
          redirect_to("#{ENV['FRONT_END_ENDPOINT']}/sign-in?status=fail")
        end
      end

      def sign_in
        cmd = Api::V1::Authenticate::SignIn.call(params)

        if cmd.success?
          render json: cmd.result, status: :ok
        else
          render json: cmd.result, status: :unprocessable_entity
        end
      end

      private

      def permitted_params
        params.require(:authenticate).permit!
      end
    end
  end
end
