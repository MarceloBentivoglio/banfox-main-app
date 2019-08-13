class CheckingAccountPolicy < ApplicationPolicy

  def destroy?
    true
  end
end
