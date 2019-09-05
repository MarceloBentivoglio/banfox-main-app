class CreateDocumentJob < ApplicationJob
  queue_as :default

  def perform(operation, seller)
    d4sign = D4Sign.new(operation, seller)
    operation.create_document(seller, d4sign)
    operation.add_webhook(d4sign)
    operation.add_signer_list(seller, d4sign)
    operation.prepare_to_sign(d4sign)
    operation.save!
    operation.completed!
    operation.notify_joint_debtors(seller)
    operation.notify_banfox_signer
  end
end
