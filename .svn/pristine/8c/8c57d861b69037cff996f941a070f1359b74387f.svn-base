# class WIFI
  require 'openssl'
  require 'base64'
  class AesEncryptDecrypt
    def self.encryption(key, msg, algorithm)
      cipher = OpenSSL::Cipher.new(algorithm)
      cipher.encrypt()
      cipher.key = key
      crypt = cipher.update(msg) + cipher.final()
      crypt_string = (Base64.encode64(crypt))
      return crypt_string
    end

    def self.decryption(key, msg, algorithm)
      cipher = OpenSSL::Cipher.new(algorithm)
      cipher.decrypt()
      cipher.key = key
      tempkey = Base64.decode64(msg)
      crypt = cipher.update(tempkey)
      crypt << cipher.final()
      return crypt
    end
  end
# end

# KEY ="***************************************"
KEY ="***************************************"

p AesEncryptDecrypt.encryption(
    KEY, "12345678", "AES-128-ECB"
)
p AesEncryptDecrypt.decryption(
    KEY, "auyfsssISvD13A4EVIKv4A==\n", "AES-128-ECB"
)

# mCwOIMl+EG2DFUkIaOHCpQ==
# gurudath

# AesEncryptDecrypt.encryption(
#     KEY, "gurudath", "AES-256-CBC"
#
# )
# AesEncryptDecrypt.decryption(
#     KEY, "jbhZh7fl0oUAM1xU+kQyAw==", "AES-256-CBC"
# )

# jbhZh7fl0oUAM1xU+kQyAw==
# gurudath