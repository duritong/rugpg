require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe GPGME::Key do
  it "should have a .find_exact method" do
    GPGME::Key.should respond_to(:find_exact)
  end
  describe :find_exact do
    it "wraps an email address with angle brackets" do
      GPGME::Key.expects(:find).with(:public,['<bar@example.com>'],[])
      GPGME::Key.find_exact(:public,'bar@example.com')
    end
    
    it "wraps multiple email addresses with angle brackets" do
      GPGME::Key.expects(:find).with(:public,['<bar@example.com>','<foo@example.com>'],[])
      GPGME::Key.find_exact(:public,['bar@example.com','foo@example.com'])
    end
    
    it "does not touch other strings than email addresses" do
      GPGME::Key.expects(:find).with(:public,['Bar Example'],[])
      GPGME::Key.find_exact(:public,'Bar Example')
    end
    
    it "does the same in mixed mode" do
      GPGME::Key.expects(:find).with(:public,['<bar@example.com>','Foo Example'],[])
      GPGME::Key.find_exact(:public,['bar@example.com','Foo Example'])
    end
  end
end
