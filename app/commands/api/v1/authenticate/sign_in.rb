module Api
  module V1
    module Authenticate
      class SignIn
        prepend SimpleCommand
        prepend SimpleResponse

        def initialize(opts = {})
          @opts = opts
        end

        def call
          unless user && valid_password
            return response(message: 'The email address or password is incorrect.')
          end

          unless user.activated
            return response(message: 'This account is not activated yet.')
          end

          success_response
        end

        private

        attr_reader :opts

        def success_response
          response(
            data: {
              token: token,
              # user_profile: CustomerProfilePresenter.json(user)
            }
          )
        end

        def user
          @user ||= User.find_by_email(opts[:email])
        end

        def valid_password
          user.authenticate(opts[:password])
        end

        def token
          JsonWebToken.encode(user_id: user.id)
        end
      end
    end
  end
end
