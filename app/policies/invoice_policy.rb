class InvoicePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    return true
  end

  def destroy?
    !record.deposited?
  end
end
