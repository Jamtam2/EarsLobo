class InquiryMailer < ApplicationMailer
    default from: 'dichoticdataresearch@gmail.com'
  
    def inquiry_email(inquiry)
      @inquiry = inquiry
      mail(to: 'dichoticdataresearch@gmail.com', subject: 'New Dataset Inquiry')
    end
  
    def confirmation_email(inquiry)
      @inquiry = inquiry
      mail(to: @inquiry.email, subject: 'We have received your inquiry')
    end
  end
  