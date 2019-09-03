class SignDocumentMailer < ApplicationMailer

  default from: 'joao@banfox.com.br'

  def joint_debtor(name, email, signature_key, operation)
    @name = name.split.first
    @signature_key = signature_key
    @operation = operation

    mail(
      to: email,
      subject: "Assinar documento de aditivo de operação"
      )
  end

  def banfox_signer(email, signature_key, operation)
    @signature_key = signature_key
    @operation = operation

    mail(
    to: email,
    subject: "Assinar documento de aditivo da operação \# #{@operation.id}"
    )
  end

end
