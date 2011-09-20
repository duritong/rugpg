require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')


describe Rugpg::Keyring::Management do
  
  subject{ Rugpg.open_keyring(File.expand_path(File.dirname(__FILE__) + '/../../data/management_test')) }
  
    before(:each) do
    keyring_base = File.expand_path(File.dirname(__FILE__) + '/../../data/management')
    keyring_test = "#{keyring_base}_test"
    require 'fileutils'
    FileUtils.rm_rf keyring_test if File.directory?(keyring_test)
    
    FileUtils.cp_r(keyring_base,keyring_test)
  end
  
  describe ".import_key" do
    it "imports a key into a keyring" do
      subject.get_exact_public_key('tester1@example.com').should be_nil
      (import=subject.import_key(File.read(File.join(subject.location,'tester1.pub')))).should_not be_nil
      import.imports.first.fingerprint.should eql('173EED0E415F91067752C75BAEDB1A7000E3CE14')
      subject.get_exact_public_key('tester1@example.com').should_not be_nil
    end
  end
  
  describe ".import_key_from_file" do
    it "imports a key directly from a file" do
      subject.get_exact_public_key('tester1@example.com').should be_nil
      (import = subject.import_key_from_file(File.join(subject.location,'tester1.pub'))).should_not be_nil
      import.imports.first.fingerprint.should eql('173EED0E415F91067752C75BAEDB1A7000E3CE14')
      subject.get_exact_public_key('tester1@example.com').should_not be_nil
    end
  end
  
  describe ".export_key" do
    it "exports a key from a keyring" do
      subject.export_key('tester2@example.com').should match /mQENBE53k6ABCAC3P7\+rCRMCb1LyDVZslHZhWQ3CtKJfFADGtMdtThpwNZ1Q98Bl/
    end
    
    it "exports n empty string if no key can be found" do
      subject.export_key('some_key').should be_empty
    end
    
    it "uses a strict pattern by default" do
      object = Object.new
      object.expects(:read).once.returns('')
      GPGME::Key.expects(:export).with('<tester@example.com>',{:armor => true}).returns object
      subject.export_key('tester@example.com').should be_empty
    end
    
    it "exports multiple keys if the pattern matches 2 keys" do
      subject.import_key_from_file(File.join(subject.location,'tester1.pub'))
      keys = subject.export_key('tester',false)
      (import = subject.import_key(keys)).should_not be_nil
      import.considered.should eql(2)
    end
  end
  
  describe ".generate_key" do
    # we only invoke it once due to perfomance issues
    context "without really invoking it" do
      before(:each) do
        object = Object.new
        object.expects(:fingerprint).once.returns('123')
        subject.expects(:get_exact_public_key).with('bla@example.com').once.returns(object)
        GPGME::Ctx.any_instance.expects(:generate_key)
      end
      
      it "choses a random password if none is passed" do
        Rugpg::Utils.expects(:random_password).once.returns('foo')
        
        res = subject.generate_key('foo','bla@example.com')
        res.should be_kind_of(Hash)
        res[:passphrase].should eql('foo')
        res[:fingerprint].should eql('123')
      end
      
      it "uses the passed password" do
        Rugpg::Utils.expects(:random_password).never
        
        res = subject.generate_key('foo','bla@example.com','foo2')
        res.should be_kind_of(Hash)
        res[:passphrase].should eql('foo2')
        res[:fingerprint].should eql('123')
      end
    end

    context "and invoking it for real(TM)" do
      it "should generate a keypair and add it to the keyring" do
        res = subject.generate_key('foo','gentest@example.com','foo2')
        res.should be_kind_of(Hash)
        res[:passphrase].should eql('foo2')
        res[:fingerprint].should eql(subject.get_exact_public_key('gentest@example.com').subkeys.first.fingerprint)
      end
    end
  end
  
end