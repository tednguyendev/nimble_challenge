module Api
  module V1
    class BaseController < ApplicationController
      # protect_from_forgery with: :exception
      # skip_before_action :verify_authenticity_token

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

      def set_global_variables
        Current.customer = current_user
        ActiveStorage::Current.host = request.base_url
        Rails.application.routes.default_url_options[:host] = request.base_url
      end
    end
  end
end
