class AddInquiryTypeToInquiries < ActiveRecord::Migration[6.1]
  def change
    add_column :inquiries, :inquiry_type, :string
  end
end
