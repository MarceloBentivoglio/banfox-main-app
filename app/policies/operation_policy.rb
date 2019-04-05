class OperationPolicy < ApplicationPolicy

  def destroy?
    !record.installments.any? {|installment| installment.deposited?}
  end

  def sign_document_status?
    return true
  end
end
