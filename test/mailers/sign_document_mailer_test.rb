require 'test_helper'

class SignDocumentMailerTest < ActionMailer::TestCase
  test "joint_debtor" do
    mail = SignDocumentMailer.joint_debtor
    assert_equal "Joint debtor", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
