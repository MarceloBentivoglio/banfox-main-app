# == Schema Information
#
# Table name: billing_rulers
#
#  id           :bigint           not null, primary key
#  billing_type :integer
#  status       :integer
#  code         :string
#  seller_id    :bigint
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_billing_rulers_on_seller_id  (seller_id)
#

class BillingRuler < ApplicationRecord
  belongs_to :seller
  has_and_belongs_to_many :installments

  #TODO expired status after one day withou response
  enum status: {
    sent_to_seller: 0,
    paid:           1,
    not_paid:       2,
    ready:          3,
  }

  enum billing_type: {
    due_date:             0,
    just_overdued:        1,
    overdue:              2,
    overdue_pre_serasa:   3,
    sending_to_serasa:    4,
    overdue_after_serasa: 5,
    protest:              6,
    monthly_organization: 7,
    weekly_organization:  8,
  }

  def created_at_format
    created_at.strftime("%d/%m/%Y") unless created_at.nil?
  end

  def status_translate
      case status
      when "sent_to_seller"
        "Enviado ao Seller"
      when "paid"
        "Pago"
      when "not_paid"
        "Não Pago"
      when "ready"
        "Pronto para Envio"
      end
  end

  def billing_type_translate
    case billing_type
    when "due_date"
      "Vencem Hoje"
    when "just_overdued"
      "1º dia de vencimento"
    when "overdue"
      "4~9 dias após vencimento"
    when "overdue_pre_serasa"
      "10~19 dias após vencimento"
    when "sending_to_serasa"
      "serão negativados"
    when "overdue_after_serasa"
      "21~29 dias após vencimento"
    when "protest"
      "Serão protestados"
    end
  end
end
