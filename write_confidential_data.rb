require 'openssl'
require 'base64'
require 'byebug'

def crypt_file(alg, pass, salt, file)
  puts "--Setup--"
  puts %(cipher alg:    "#{alg}")
  puts %(password:      "#{pass}")
  puts %(salt:          "#{salt}")
  puts

  puts "--Encrypting--"
  puts "..."
  text = Base64.encode64(file.read)
  enc = OpenSSL::Cipher.new(alg)
  enc.encrypt
  enc.pkcs5_keyivgen(pass, salt)
  cipher =  enc.update(text)
  cipher << enc.final

  crypted_file = File.new("encrypted_file", "w")
  crypted_file.puts cipher
  crypted_file.close
end

def decrypt_file(alg, pass, salt, file)
  puts "--Decrypting--"
  dec = OpenSSL::Cipher.new(alg)
  dec.decrypt
  dec.pkcs5_keyivgen(pass, salt)
  plain =  dec.update(file.read)

  File.open('new_generated_file', 'wb') do |f|
    f.write(Base64.decode64(plain))
  end
  puts "..."
end

def ciphers
  ciphers = OpenSSL::Cipher.ciphers.sort
  ciphers.each{|i|
    if i.upcase != i && ciphers.include?(i.upcase)
      ciphers.delete(i)
    end
  }
  return ciphers
end

puts "Supported ciphers in #{OpenSSL::OPENSSL_VERSION}:"
ciphers.each_with_index{|name, i|
  printf("%-15s", name)
  puts if (i + 1) % 5 == 0
}
puts
puts

crypt_by_password(alg, pass, salt, text)

puts "Encrypting File"
file = File.open('bacon.jpg', 'rb')
crypt_file(alg, pass, salt, file)
file = File.new('encrypted_file', 'rb')
decrypt_file(alg, pass, salt, file)
