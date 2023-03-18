module Api
  module V1
    class AuthorizeApiRequest
      prepend SimpleCommand

      def initialize(opts = {})
        @opts = opts
      end

      def call
        user
      end

      private

      attr_reader :opts

      def user
        return @user if @user

        @user = User.find_by_id(opts.dig(:token, 'user_id'))
        @user || errors.add(:token, 'is invalid') && nil
      end
    end
  end
end
