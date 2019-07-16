# == Schema Information
#
# Table name: installments
#
#  id                          :bigint           not null, primary key
#  number                      :string
#  value_cents                 :bigint           default(0), not null
#  value_currency              :string           default("BRL"), not null
#  initial_fator_cents         :bigint           default(0), not null
#  initial_fator_currency      :string           default("BRL"), not null
#  initial_advalorem_cents     :bigint           default(0), not null
#  initial_advalorem_currency  :string           default("BRL"), not null
#  initial_protection_cents    :bigint           default(0), not null
#  initial_protection_currency :string           default("BRL"), not null
#  due_date                    :date
#  ordered_at                  :datetime
#  deposited_at                :datetime
#  finished_at                 :datetime
#  backoffice_status           :integer          default("backoffice_status_not_set")
#  liquidation_status          :integer          default("liquidation_status_not_set")
#  unavailability              :integer          default("unavailability_not_set")
#  rejection_motive            :integer          default("rejection_motive_not_set")
#  import_ref                  :string
#  invoice_id                  :bigint
#  operation_id                :bigint
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  final_fator_cents           :bigint           default(0), not null
#  final_fator_currency        :string           default("BRL"), not null
#  final_advalorem_cents       :bigint           default(0), not null
#  final_advalorem_currency    :string           default("BRL"), not null
#  final_protection_cents      :bigint           default(0), not null
#  final_protection_currency   :string           default("BRL"), not null
#  veredict_at                 :datetime
#

require "test_helper"

class InstallmentTest < ActiveSupport::TestCase

  def installment_overdue
    @i ||= Installment.new(
      number: "3",
      value: Money.new(100000),
      due_date: Date.current - 1,
      backoffice_status: "deposited",
      liquidation_status: "opened",
    )
  end

  test "calculating delta fator" do
    installment_overdue.stubs(:invoice).returns(mock())
    installment_overdue.invoice.stubs(:fator).returns(0.04)

    expected = 0

    assert_equal expected, installment_overdue.delta_fator
  end
end
