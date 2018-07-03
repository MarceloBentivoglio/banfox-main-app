class OperationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def store?
    return true
  end

  def opened?
    return true
  end

  def history?
    return true
  end

  def destroy?
    !record.invoices.any? {|invoice| invoice.deposited?}
  end
end
