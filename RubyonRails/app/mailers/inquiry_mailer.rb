class InquiryMailer < ApplicationMailer
  default from: 'dichoticdataresearch@gmail.com'

  def inquiry_email(inquiry)
    @inquiry = inquiry
    # puts "Got here: #{inquiry.inspect}"

    mail(to: 'dichoticdataresearch@gmail.com', subject: 'New Inquiry Received')
  end

  def confirmation_email(inquiry)
    @inquiry = inquiry

    case @inquiry.inquiry_type
    when 'dataset_access'
      mail(to: @inquiry.email, subject: 'Dataset Access Inquiry Confirmation', template_name: 'confirmation_email_dataset')
    when 'bug_report'
      mail(to: @inquiry.email, subject: 'Bug Report Confirmation', template_name: 'confirmation_email_bug')
    when 'discount_inquiry'
      mail(to: @inquiry.email, subject: 'Discount Inquiry Confirmation', template_name: 'confirmation_email_discount')
    end
  end
  end
