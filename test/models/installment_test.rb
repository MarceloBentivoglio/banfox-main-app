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
    expected = 1.29
    assert_equal expected, installment_overdue.delta_fator
  end
end
