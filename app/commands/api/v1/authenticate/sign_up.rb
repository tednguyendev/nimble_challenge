module Api
  module V1
    module Authenticate
      class SignUp
        prepend SimpleCommand
        prepend SimpleResponse

        def initialize(opts = {})
          @opts = opts
        end

        def call
          if user_exist?
            return response(message: 'The email address is already exists.')
          end

          unless new_user&.save
            errors.add(:parameter, new_user.errors.to_h)

            return response
          end

          send_welcome_mail
          response
        end

        private

        attr_reader :opts

        def user_exist?
          User.exists?(email: opts[:email])
        end

        def send_welcome_mail
          UserMailer.welcome(new_user.id).deliver_later
        end

        def new_user
          @new_user ||=
            User.new(
              email: opts[:email],
              password: opts[:password],
            )
        end
      end
    end
  end
end
