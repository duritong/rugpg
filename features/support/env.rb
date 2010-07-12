require File.dirname(__FILE__) + "/../../lib/rugpg"

gem 'cucumber'
require 'cucumber'
gem 'rspec'
require 'spec'

Before do
  @tmp_root = File.dirname(__FILE__) + "/../../tmp"
  @home_path = File.expand_path(File.join(@tmp_root, "home"))
  @lib_path  = File.expand_path(File.dirname(__FILE__) + "/../../lib")
  FileUtils.rm_rf   @tmp_root
  FileUtils.mkdir_p @home_path
  ENV['HOME'] = @home_path
  
  @tmp_gnupghome = File.join(@home_path,'tmp-gnupghome')
  @test_data_home = File.join(File.dirname(__FILE__),'..','testdata')
    
  @keys = {
    :unexpiring_public_key1_path => File.join(@test_data_home,'unexpiring.testkey1.pub'),
    :unexpiring_secret_key1_path => File.join(@test_data_home,'unexpiring.testkey1.priv'),
    :unexpiring_public_key1_passphrase => 'rugpgtest',
    :unexpiring_public_key2_path => File.join(@test_data_home,'unexpiring.testkey2.pub'),
    :unexpiring_secret_key2_path => File.join(@test_data_home,'unexpiring.testkey2.priv'),
    :unexpiring_public_key2_passphrase => 'rugpgtest',
    :unexpiring_public_key2old_path => File.join(@test_data_home,'unexpiring.testkey2old.pub'),
    :unexpiring_secret_key2old_path => File.join(@test_data_home,'unexpiring.testkey2old.priv'),
    :unexpiring_public_key2old_passphrase => 'rugpgtest',
  }
end
