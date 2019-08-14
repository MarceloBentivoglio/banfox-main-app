class SignDocumentMailerPreview < ActionMailer::Preview
  def joint_debtor
    SignDocumentMailer.joint_debtor("Debtor Test", "debtor@mail.com", "debtorkey").deliver_now
  end
  
  def banfox_signer
    SignDocumentMailer.banfox_signer("signer@banfox.com.br", "banfoxsignerkey", Operation.first.id).deliver_now
  end
end
