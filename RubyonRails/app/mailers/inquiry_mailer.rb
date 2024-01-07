class InquiryMailer < ApplicationMailer
  default from: 'dichoticdataresearch@gmail.com'

  def inquiry_email(inquiry)
    @inquiry = inquiry
    puts "Got here: #{inquiry.inspect}"

    mail(to: 'dichoticdataresearch@gmail.com', subject: 'New Inquiry Received')
  end

  def confirmation_email(inquiry)
    @inquiry = inquiry

    if @inquiry.inquiry_type == 'dataset_access'
      mail(to: @inquiry.email, subject: 'Dataset Access Inquiry Confirmation', template_name: 'confirmation_email_dataset')
    elsif @inquiry.inquiry_type == 'bug_report'
      mail(to: @inquiry.email, subject: 'Bug Report Confirmation', template_name: 'confirmation_email_bug')
    end
  end
end
