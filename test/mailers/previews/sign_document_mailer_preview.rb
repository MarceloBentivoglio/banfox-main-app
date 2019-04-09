# Preview all emails at http://localhost:3000/rails/mailers/sign_document_mailer
class SignDocumentMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/sign_document_mailer/joint_debtor
  def joint_debtor
    SignDocumentMailer.joint_debtor("Joaquim Oliveira", "joaquim@banfox.com.br", "8cbd33fc-788c-412a-ac49-d9f763c11376")
  end

end
