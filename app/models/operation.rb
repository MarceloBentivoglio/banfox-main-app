class Operation < ApplicationRecord
  has_many :installments, dependent: :nullify
  has_many :rebuys
  validates :consent, acceptance: {message: "é necessário dar o seu aval para a operação"}
  default_scope { order(created_at: :asc) }
  # dar um preload das installemnts aqui
  scope :last_from_seller, -> (seller) { joins(installments: [invoice: [:seller]]).where("sellers.id": seller.id).distinct }
  include Trackable

  def statuses
    {
      no_on_going_operation: "Nenhuma operação",
      in_analysis: "Em análise",
      completely_approved: "Completamente aprovada",
      completely_rejected: "Completamente rejeitada",
      partially_approved: "Parcialmente aprovada",
    }
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

  def ready_to_sign?
    completely_approved? || partially_approved?
  end

  def consent_rejection!
    installments.each { |i| i.rejected_consent! }
  end

  def deposit_money
    installments.each do |i|
        #In fact here we would have another step where we have to confirm that we have deposited the money before changing the status to deposited
        i.opened!
        i.deposited!
    end
  end

  def total_value
    installments.reduce(Money.new(0)){|total, i| total + i.value}
  end

  def total_value_approved
    installments.reduce(Money.new(0)){|total, i| total + (i.approved? ? i.value : Money.new(0))}
  end

  def fee
    installments.reduce(Money.new(0)){|total, i| total + i.fee}
  end

  def net_value
    installments.reduce(Money.new(0)){|total, i| total + i.net_value}
  end

  def net_value_approved
    installments.reduce(Money.new(0)){|total, i| total + (i.approved? ? i.net_value : Money.new(0))}
  end

  def protection
    0.1 * total_value
  end

  def deposit_today
    net_value - protection
  end
end
