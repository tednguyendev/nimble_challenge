# frozen_string_literal: true

class ReportMailer < ApplicationMailer
  def report_status(report_id)
    report = Report.find_by_id(report_id)

    if report.present?
      @url = "#{ENV['FRONT_END_ENDPOINT']}/reports/#{report.id}"

      mail(to: report.user.email, subject: "Your report scraping is done! 🎉")
    end
  end
end
