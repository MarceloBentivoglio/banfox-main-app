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

  def setup
    @i = Installment.new(
      value: Money.new(1000000),
      backoffice_status: "deposited",
      liquidation_status: "opened",
      initial_fator: Money.new(42433),
      initial_advalorem: Money.new(1132)
    )
    @i.stubs(:invoice).returns(mock())
    @i.invoice.stubs(:fator).returns(0.039)
    @i.invoice.stubs(:advalorem).returns(0.001)
  end

  test ".delta_fator for installment onverdue" do
    i = @i.tap do |ins|
      ins.ordered_at = Date.current - 35
      ins.due_date = Date.current - 4
    end

    expected = Money.new(-1221)

    assert_equal expected, i.delta_fator
  end

  test ".delta_advalorem for installment onverdue" do
    i = @i.tap do |ins|
      ins.ordered_at = Date.current - 35
      ins.due_date = Date.current - 4
    end

    expected = Money.new(-33)

    assert_equal expected, i.delta_advalorem
  end

  test ".delta_fator for installment on time to be settled" do
    i = @i.tap do |ins|
      ins.ordered_at = Date.current - 34
      ins.due_date = Date.current - 3
    end

    expected = Money.new(0)

    assert_equal expected, i.delta_fator
  end

  test ".delta_advalorem for installment on time to be settled" do
    i = @i.tap do |ins|
      ins.ordered_at = Date.current - 34
      ins.due_date = Date.current - 3
    end

    expected = Money.new(0)

    assert_equal expected, i.delta_advalorem
  end

  test ".delta_fator for installment paid in advance" do
    i = @i.tap do |ins|
      ins.ordered_at = Date.current - 30
      ins.due_date = Date.current + 1
    end

    expected = Money.new(4897)

    assert_equal expected, i.delta_fator
  end

  test ".delta_advalorem for installment paid in advance" do
    i = @i.tap do |ins|
      ins.ordered_at = Date.current - 30
      ins.due_date = Date.current + 1
    end

    expected = Money.new(133)

    assert_equal expected, i.delta_advalorem
  end


end
