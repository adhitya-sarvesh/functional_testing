# required implementation for encrypted credentials, unavoidable at the moment
class PasswordEncryptor
  class EncryptError < StandardError; end
  class DecryptError < StandardError; end

  class << self
    def encrypt(clear_text)
      fail EncryptError if clear_text.blank?

      cipher = OpenSSL::Cipher::AES.new(128, :CBC)
      cipher.encrypt
      cipher.key = key
      cipher.iv = iv

      (cipher.update(clear_text) + cipher.final).unpack('H*')[0].upcase
    end

    def decrypt(encrypted_text)
      fail DecryptError if encrypted_text.blank?

      cipher = OpenSSL::Cipher::AES.new(128, :CBC)
      cipher.decrypt
      cipher.key = key
      cipher.iv = iv

      encrypted_text = [encrypted_text].pack('H*').unpack('C*').pack('c*')
      cipher.update(encrypted_text) + cipher.final
    end

    private

    def key
      Digest::SHA1.hexdigest(secrets_config 'secrets_key')
    end

    def iv
      Digest::SHA1.hexdigest(secrets_config 'secrets_iv')
    end

    def secrets_config(field)
      YAML.load_file('config/application.yml')[Rails.env][field]
    end
  end
end
