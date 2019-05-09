puts "Creating doc parser user......."

user1 = User.create!(
  email: Rails.application.credentials[:production][:doc_parser][:user_mail],
  password: rand.to_s[2..11],
  authentication_token: Rails.application.credentials[:production][:doc_parser][:user_token],
  admin: false
)
