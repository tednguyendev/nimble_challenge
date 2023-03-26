class ApplicationMailer < ActionMailer::Base
  default from: (ENV['EMAIL'] || 'from@example.com')
  layout 'mailer'
end
