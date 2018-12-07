class Contact < MailForm::Base
  attribute :name,      :validate => true
  attribute :email,     :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :phone,      :validate => true
  attribute :message
  attribute :nickname,  :captcha  => true

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      :subject => "Contato Banfox Website",
      :to => "marcelo.bentivoglio@banfox.com.br; joaquim@banfox.com.br",
      :from => "joaquim@banfox.com.br"
    }
  end
end
