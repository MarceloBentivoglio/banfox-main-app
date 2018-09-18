class InvoicePolicy < ApplicationPolicy

  def destroy?
    !record.installments.any? {|installment| installment.deposited?}
  end
end
