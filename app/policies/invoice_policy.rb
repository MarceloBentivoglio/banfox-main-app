class InvoicePolicy < ApplicationPolicy

  def destroy?
    !record.deposited?
  end
end
