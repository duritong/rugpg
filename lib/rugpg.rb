$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'gpgme'
require 'rugpg/keyring'

module RuGPG
  VERSION = '0.0.1'
  
  # Opens a keyring at the given +location+
  # If +location+ is nil, the GNUPGHOME environment variable will be used.
  def self.open_keyring(location=nil)
    RuGPG::Keyring.new(location)
  end
end

