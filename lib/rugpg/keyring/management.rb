require 'rugpg/keyring/helpers'
module RuGPG
  module KeyringManagement
    include ::RuGPG::KeyringHelpers
    
    # Import +keydata+ into public key ring of the list
    def import_key(keydata)
      GPGME.import(keydata)
    end
    
    # Import key from +keyfile+
    def import_key_from_file(keyfile)
      import_key(File.read(keyfile))
    end
    
    # Exports the public key matching +keyid+ as ascii key block.
    def export_key(pattern,strict=true)
      GPGME.export(strict_pattern(pattern,strict), :armor=>:true)
    end
    
    # Generate a key with +name+, +email+ and an optional +passphrase+, which
    # expires in 2 years from now on.
    # If +passphrase+ is nil, we generate a random 32 character password
    # Further options can be tweaked in +additional_options+, such as:
    #   * +typ+ Default: RSA
    #   * +length+ Default: 2048
    #   * +sub_typ+ Default: RSA
    #   * +sub_length+ Default: 2048
    #   * +comment+ Default: empty
    #   * +expiry_date+ Default: Time.now + 2 years
    def generate_key(name,email,passphrase=nil,additional_options={})
      GPGME::Ctx.new.genkey(
        "<GnupgKeyParms format=\"internal\">
Key-Type: #{additional_options[:type]||'RSA'}
Key-Length: #{additional_options[:length]||'2048'}
Subkey-Type: #{additional_options[:sub_type]||'RSA'}
Subkey-Length: #{additional_options[:sub_length]||'2048'}
Name-Real: #{name}
Name-Comment: #{additional_options[:comment]||''}
Name-Email: #{email}
Expire-Date: #{additional_options[:expiry_date]||(Time.now + 3600 *24*365*2).strftime('%Y-%m-%d')}
Passphrase: #{passphrase||passphrase=RuGPG::Utils.instance.random_password}
</GnupgKeyParms>",
      nil,nil
    )
    passphrase
  end
  
  def progfunc(hook, what, type, current, total)
    $stderr.write("#{what}: #{current}/#{total}\r")
    $stderr.flush
  end

  private
  def self.import_keypair(list,list_privatekeyfile,list_publickeyfile)
    crypt = Schleuder::Crypt.new(list.config.gpg_password)
    Schleuder.log.debug "Importing private key from #{list_privatekeyfile}"
    crypt.add_key_from_file(list_privatekeyfile)
    Schleuder.log.debug "Importing public key from #{list_publickeyfile}"
    crypt.add_key_from_file(list_publickeyfile)
  end
    
  def self.create_gnupg_params_template(name,email,pass,type,length,sub_type,sub_length)
    "<GnupgKeyParms format=\"internal\">
Key-Type: #{type}
Key-Length: #{length}
Subkey-Type: #{sub_type}
Subkey-Length: #{sub_length}
Name-Real: #{name}
Name-Comment: schleuder list
Name-Email: #{email}
Expire-Date: 0
Passphrase: #{pass}
</GnupgKeyParms>"
  end
  end
end