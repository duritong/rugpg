module Rugpg
  class Keyring
    module Management
      include ::Rugpg::Keyring::Helper
      
      # Import +keydata+ into public key ring of the list
      def import_key(keydata)
        GPGME::Key.import(keydata)
      end
      
      # Import key from +keyfile+
      def import_key_from_file(keyfile)
        import_key(File.read(keyfile))
      end
      
      # Exports the public key matching +keyid+ as ascii key block.
      def export_key(pattern,strict=true)
        GPGME::Key.export((strict ? strict_pattern(pattern) : pattern), :armor=>true).read
      end
      
      # Generate a key with +name+, +email+ and an optional +passphrase+, which
      # expires in 2 years from now on.
      # If +passphrase+ is nil, we generate a random 32 character password
      # Further options can be tweaked in +additional_options+, such as:
      #   * +:type+ Default: RSA
      #   * +:length+ Default: 2048
      #   * +:sub_type+ Default: RSA
      #   * +:sub_length+ Default: 2048
      #   * +:comment+ Default: empty
      #   * +:expiry_date+ Default: Time.now + 2 years
      def generate_key(name,email,passphrase=nil,additional_options={})
        passphrase ||= Rugpg::Utils.random_password
        # in two years by default
        additional_options[:expiry_date]||=(Time.now + 3600 *24*365*2).strftime('%Y-%m-%d')
        
        secret = GPGME::Data.new
        public = GPGME::Data.new
        GPGME::check_version('0.0.0') if GPGME.respond_to? 'check_version'

        GPGME::Ctx.new.generate_key(
        "<GnupgKeyParms format=\"internal\">
Key-Type: #{additional_options[:type]||'RSA'}
Key-Length: #{additional_options[:length]||'2048'}
Subkey-Type: #{additional_options[:sub_type]||'RSA'}
Subkey-Length: #{additional_options[:sub_length]||'2048'}
Name-Real: #{name}
Name-Comment: #{additional_options[:comment]||"#{name}'s key"}
Name-Email: #{email}
Expire-Date: #{additional_options[:expiry_date]}
Passphrase: #{passphrase}
</GnupgKeyParms>",
        nil,nil
        )
        key = get_exact_public_key(email)
        { :fingerprint => key.fingerprint, :passphrase => passphrase }
      end
    end
  end
end