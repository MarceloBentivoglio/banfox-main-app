class OperationPolicy < ApplicationPolicy

  def destroy?
    !record.installments.any? {|installment| installment.deposited?}
  end
end
