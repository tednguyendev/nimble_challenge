module Api
  module V1
    module Authenticate
      class VerifyEmail
        prepend SimpleCommand
        prepend SimpleResponse

        def initialize(opts = {})
          @opts = opts
        end

        def call
          unless token.present? && user.present?
            return response(message: 'Token is not valid.')
          end

          if user.activated
            return response(message: 'This account is already activated.')
          end

          user.update(activated: true)

          response(data: { token: new_token })
        end

        private

        attr_reader :opts

        def user
          @user ||= User.find_by_id(token[:user_id])
        end

        def token
          @token ||= ::JsonWebToken.decode(opts[:token])
        end

        def new_token
          JsonWebToken.encode(user_id: user.id)
        end
      end
    end
  end
end
