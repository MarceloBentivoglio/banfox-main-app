class OperationPolicy < ApplicationPolicy

  def destroy?
    !record.invoices.any? {|invoice| invoice.deposited?}
  end
end
