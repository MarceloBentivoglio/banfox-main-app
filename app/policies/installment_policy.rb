class InstallmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def destroy?
    !record.invoice.deposited?
  end
end
