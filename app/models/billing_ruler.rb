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

  enum status: {
    send_to_seller: 0,
    paid:           1,
    not_paid:       2,
  }

  enum billing_type: {
    due_date:             0,
    just_overdued:        1,
    overdue:              2,
    overdue_pre_serasa:   3,
    sending_to_serasa:    4,
    overdue_after_serasa: 5,
    protest:              6,
  }

end
