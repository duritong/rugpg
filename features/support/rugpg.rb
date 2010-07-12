module RuGPGHelpers
  def empty_keyring
    FileUtils.rm_rf(@tmp_gnupghome)
    Dir.mkdir(@tmp_gnupghome)
    @keyring = RuGPG.open_keyring(@tmp_gnupghome)
    @keyring.list_all_keys.size.should == 0
  end
  
  def keyring(amount=0)
    empty_keyring
    (1..amount.to_i).each{|i| import_key(i) }
  end
  
  def import_key(key_nr, mode='public')
    @keyring.import_key_from_file(@keys["unexpiring_#{mode}_key#{key_nr}_path".to_sym])
  end
  
  def import_secret_key(key_nr)
    import_key(key_nr,'secret')
  end
end

World(RuGPGHelpers)