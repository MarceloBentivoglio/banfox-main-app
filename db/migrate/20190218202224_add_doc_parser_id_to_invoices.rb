class AddDocParserIdToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :issue_date, :date
    add_column :invoices, :doc_parser_ref, :string
    add_column :invoices, :doc_parser_ticket, :jsonb
    add_column :invoices, :doc_parser_data, :jsonb
  end
end
