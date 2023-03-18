# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def welcome(user_id)
    user = User.find_by_id(user_id)

    if user.present?
      token = JsonWebToken.encode(user_id: user.id)
      @url = "#{ENV['BASE_ENDPOINT']}/api/v1/verify-email?token=#{token}"
      subject = "Verify your Email"
      email = user.email

      mail(to: email, subject: "Welcome to Nimble Web Crawler Service! 👋🏻")
    end
  end
end
