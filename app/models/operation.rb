class Operation < ApplicationRecord
  has_many :installments
  has_many :rebuys, dependent: :destroy
  validates :consent, acceptance: {message: "é necessário dar o seu aval para a operação"}
  default_scope { order(created_at: :asc) }
  scope :last_from_seller, -> (seller) { joins(installments: [invoice: [:seller]]).where("sellers.id": seller.id).distinct.last }

  def analysis_finished?
    installments.all? { |i| i.approved? || i.rejected?}
  end

  def completely_approved?
    installments.all? { |i| i.approved? }
  end

  def completely_rejected?
    installments.all? { |i| i.rejected? }
  end
end
