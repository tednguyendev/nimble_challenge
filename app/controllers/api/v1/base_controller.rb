module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_request!

      def authenticate_request!
        unless current_user
          render json: { errors: 'Not Authorized' }, status: :unauthorized
          return
        end

        unless current_user&.activated?
          render json: { errors: 'This account is not activated yet.' }, status: :unauthorized
          return
        end

        current_user
      end

      def current_user
        @current_user ||= Api::V1::AuthorizeApiRequest
                              .call(
                                  token: auth_token
                                )
                              .result
      end

      def auth_token
        @auth_token ||= JsonWebToken.decode(request.headers['Authorization'].to_s.gsub('Bearer ', ''))
      end

      protected
    end
  end
end
