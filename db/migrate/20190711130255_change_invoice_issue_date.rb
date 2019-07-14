class ChangeInvoiceIssueDate < ActiveRecord::Migration[5.2]
  def change
    change_column :invoices, :issue_date, :datetime
    rename_column :invoices, :issue_date, :issued_at
  end
end
