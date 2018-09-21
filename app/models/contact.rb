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
      :subject => "Contato MVP Invest Website",
      :to => "marcelo.bentivoglio@mvpinvest.com.br; joaquim.oliveira@mvpinvest.com.br",
      :from => "joaquim.oliveira@mvpinvest.com.br"
    }
  end
end
