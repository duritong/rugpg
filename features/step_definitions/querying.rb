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