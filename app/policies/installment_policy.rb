class InstallmentPolicy < ApplicationPolicy

  def destroy?
    !record.deposited?
  end
end
