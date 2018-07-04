class InstallmentPolicy < ApplicationPolicy

  def destroy?
    !record.invoice.deposited?
  end
end
