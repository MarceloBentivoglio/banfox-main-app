class CorporateEmailValidator < ActiveModel::EachValidator
  INVALID_EMAILS = ["hotmail", "gmail", "icloud", "me", "bol", "uol", "outlook", "mac", "aol", "yahoo", "rocketmail", "terra", "live", "mail", "email", "imail"]
  def validate_each(record, attribute, value)
    @corporate_email = true
    regexp  = /(?<=@)[^.]+(?=\.)/
    domain = regexp.match(value).to_s
    check_corporate_domain(domain)
    record.errors.add(:email, "é necessário um e-mail corporativo") unless @corporate_email
  end

  private

  def check_corporate_domain(domain)
    @corporate_email = false if INVALID_EMAILS.include?(domain)
  end

end
