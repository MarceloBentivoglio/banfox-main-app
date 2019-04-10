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
      signing_process: "Em processo de assinatura"
    }
  end

  def no_on_going_operation?
    installments.all? { |i| i.deposited? || i.rejected_consent?}
  end

  def in_analysis?
    installments.any? { |i| i.ordered? }
  end

  def completely_approved?
    !sign_document_key? && installments.all? { |i| i.approved? }
  end

  def completely_rejected?
    installments.all? { |i| i.rejected? }
  end

  # Keep this first part !sign_document_key? only until the rejections in oprations are treated
  def partially_approved?
    !sign_document_key? && installments.any? { |i| i.approved? } && installments.any? { |i| i.rejected? || i.rejected_consent? } && installments.all? { |i| i.approved? || i.rejected? || i.rejected_consent?}
  end

  def signing_process?
    sign_document_key?
  end

  def signer_signature_keys
    signature_keys.deep_symbolize_keys[:signer_signature_keys]
  end


  def notify_seller(seller)
    #TO DO: Create a logic to select the user when we have multiple users
    user = seller.users.first
    if completely_approved?
      OperationMailer.approved(self, user, seller).deliver_now
    elsif completely_rejected?
      OperationMailer.rejected(self, user, seller).deliver_now
    elsif partially_approved?
      OperationMailer.partially_approved(self, user, seller).deliver_now
      #TODO: create a method that has a better name for completely deposited
    elsif no_on_going_operation?
      OperationMailer.deposited(self, user, seller).deliver_now
    end
  end

  def notify_joint_debtors(seller)
    signer_signature_keys.each do |signer_signature_key|
      joint_debtor = seller.joint_debtors.find do |joint_debtor|
        joint_debtor.email == signer_signature_key[:email]
      end
      if joint_debtor
        SignDocumentMailer.joint_debtor(joint_debtor.name, signer_signature_key[:email], signer_signature_key[:signature_key]  ).deliver_now
      end
    end
  end

  def consent_rejection!
    installments.each { |i| i.rejected_consent! }
  end

  #TODO Understand why this doesn't work
  # def signed!
  #   signed = true
  #   save!
  # end

  # def signed?
  #   signed
  # end

  def total_value
    installments.reduce(Money.new(0)){|total, i| total + i.value}
  end

  def total_value_approved
    installments.reduce(Money.new(0)){|total, i| total + (i.approved? ? i.value : Money.new(0))}
  end

  def fee
    installments.reduce(Money.new(0)){|total, i| total + i.fee}
  end

  def fee_approved
    installments.reduce(Money.new(0)){|total, i| total + (i.approved? ? i.fee : Money.new(0))}
  end

  def final_fee
    installments.reduce(Money.new(0)){|total, i| total + i.final_fator + i.final_advalorem}
  end

  def final_fator
    installments.reduce(Money.new(0)){|total, i| total + i.final_fator}
  end

  def final_advalorem
    installments.reduce(Money.new(0)){|total, i| total + i.final_advalorem}
  end

  def net_value
    installments.reduce(Money.new(0)){|total, i| total + i.net_value}
  end

  def net_value_approved
    installments.reduce(Money.new(0)){|total, i| total + (i.approved? ? i.net_value : Money.new(0))}
  end

  def final_net_value
    installments.reduce(Money.new(0)){|total, i| total + i.final_net_value}
  end

  def protection
    protection_rate * total_value
  end

  def protection_approved
    protection_rate * total_value_approved
  end

  def final_protection
    installments.reduce(Money.new(0)){|total, i| total + i.final_protection}
  end

  def deposit_today
    net_value - protection
  end

  def deposit_today_approved
    net_value_approved - protection_approved
  end

  def final_deposit_today
    final_net_value - final_protection
  end


  def seller_name
    installments.first.invoice.seller.company_name
  end

  def order_elapsed_time
    seconds_diff = (Time.current - created_at).to_i

    hours = seconds_diff / 3600
    seconds_diff -= hours * 3600

    minutes = seconds_diff / 60
    seconds_diff -= minutes * 60

    seconds = seconds_diff

    '%02d horas e %02d minutos' % [hours, minutes]
  end

  private

  def protection_rate
    installments.first.invoice.seller.protection
  end

end
