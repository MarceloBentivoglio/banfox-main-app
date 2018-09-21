class Operation < ApplicationRecord
  has_many :installments, dependent: :nullify
  has_many :rebuys
  validates :consent, acceptance: {message: "é necessário dar o seu aval para a operação"}
  default_scope { order(created_at: :asc) }
  # dar um preload das installemnts aqui
  scope :last_from_seller, -> (seller) { joins(installments: [invoice: [:seller]]).where("sellers.id": seller.id).distinct.last }

  OPERATION_STATUS = [
    :no_on_going_operation,
    :in_analysis,
    :completely_approved,
    :completely_rejected,
    :partially_approved,
  ].freeze

  def status
    OPERATION_STATUS.each do |operation_status|
      return operation_status if self.__send__("#{operation_status}?")
    end
  end

  def no_on_going_operation?
    installments.all? { |i| i.deposited? || i.rejected_consent?}
  end

  def in_analysis?
    installments.any? { |i| i.ordered? }
  end

  def completely_approved?
    installments.all? { |i| i.approved? }
  end

  def completely_rejected?
    installments.all? { |i| i.rejected? }
  end

  def partially_approved?
    installments.any? { |i| i.approved? } && installments.any? { |i| i.rejected? || i.rejected_consent? } && installments.all? { |i| i.approved? || i.rejected? || i.rejected_consent?}
  end
end
