class AddBugReportToInquiries < ActiveRecord::Migration[6.1]
  def change
    add_column :inquiries, :bug_report, :string
  end
end
