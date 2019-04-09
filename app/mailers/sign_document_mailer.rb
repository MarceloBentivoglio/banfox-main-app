class SignDocumentMailer < ApplicationMailer

  default from: 'joao@banfox.com.br'

  def joint_debtor(name, email, signature_key)
    @name = name.split.first
    @signature_key = signature_key

    mail(
      to: email,
      subject: "Assinar documento de aditivo de operação"
      )
  end
end
