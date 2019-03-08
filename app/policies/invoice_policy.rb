class InvoicePolicy < ApplicationPolicy

  def create?
    return true
  end

  def destroy?
    !record.installments.any? {|installment| installment.deposited?}
  end
end
