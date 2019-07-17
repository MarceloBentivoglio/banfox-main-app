# == Schema Information
#
# Table name: invoices_documents_bundles
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class InvoicesDocumentsBundle < ApplicationRecord
  has_many_attached :documents, dependent: :purge
end
