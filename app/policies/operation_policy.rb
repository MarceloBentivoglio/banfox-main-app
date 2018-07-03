class OperationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def store?
    return true
  end
end
