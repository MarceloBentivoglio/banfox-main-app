require 'openssl'
require 'base64'

module Security
  class Crypt

    def initialize(plain_data)
      @plain_data = plain_data
    end

    def encrypt
      plain_data_base64 = Base64.encode64(@plain_data)
      enc = OpenSSL::Cipher.new(cipher_algorithm)
      enc.encrypt
      enc.pkcs5_keyivgen(password, salt)
      cipher =  enc.update(plain_data_base64)
      cipher << enc.final

      cipher
    end

    def decrypt
      decipher = OpenSSL::Cipher.new(cipher_algorithm)
      decipher.decrypt
      decipher.pkcs5_keyivgen(password, salt)
      plain = decipher.update(@plain_data)
      plain << decipher.final

      Base64.decode64(plain)
    end

    def encrypt_file
      tempfile = Tempfile.new 
      tempfile.binmode
      tempfile.write(self.encrypt)

      tempfile
    end

    #trocar para credentials
    def cipher_algorithm
      Rails.application.credentials[Rails.env.to_sym][:security_crypt_cipher_algorithm]
    end

    def password
      Rails.application.credentials[Rails.env.to_sym][:security_crypt_cipher_password]
    end

    def salt
      Rails.application.credentials[Rails.env.to_sym][:security_crypt_cipher_salt]
    end
  end
end
