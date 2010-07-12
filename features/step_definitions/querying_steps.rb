Given /^a keyring with (.*) keys$/ do |amount|
  keyring(amount)
end

When /^I list (.*) keys$/ do |mode|
  @keys = @keyring.send("list_#{mode}_keys")
end

Then /^I should get (.*) keys$/ do |amount|
  @keys.size.should == amount.to_i
end

Given /^(.*) secret key$/ do |amount|
  (1..amount.to_i).each{|i| import_secret_key(i) }
end

When /^I query for (.*) key (.*)$/ do |mode,key|
  @keys = @keyring.send("list_#{mode}_keys",key)
end

When /^I check for (.*) key ([\w|@|\.]+)( .*)?$/ do |mode,pattern,strict|
  @found = @keyring.send("contains_#{mode}_key?",pattern,strict.nil?)
end

Then /^the key should be in the keyring$/ do
  @keyring.contains_public_key?('FBD5055E').should == true
end

Then /^I should have (.*) (.*) key in the keyring$/ do |amount,mode|
  @keyring.list_public_keys.size.should == amount.to_i
end

When /^I get exactly the (.*) key (.*)$/ do |mode,key|
  @keys = [ @keyring.send("get_exact_#{mode}_key",key) ].compact
end

Then /^the email should be (.*)$/ do |email|
  @keys.first.uids.first.email.should == email
end