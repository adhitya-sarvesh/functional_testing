class ReportMailer < ApplicationMailer
  def report(email, request_id)
    @request = Request.find_by(id: request_id)

    attachments['report.pdf'] = File.read("#{Rails.root}/spec/features/#{@request.id}/request_report-#{@request.id}.pdf")

    email = email.delete(' ').split(',')
    mail(to: email, subject: "Netra: Report #{Time.now.strftime('%d %b %Y')}")
  end
end
