Feature: Managing a GnuPG keyring
  In order to to be able to work with GnuPG Keys
  I should be able to 
  Manage the keyring
  
  Scenario: Importing a public key
    Given an empty keyring
    And a public key
    When I import this key
    Then the key should be in the keyring
    
  Scenario: Importing a public key from file
  	Given an empty keyring
    And the path to the public key 1
    When I import this key
    Then the key should be in the keyring
    
  Scenario: Importing a public key from storage numbr
  	Given an empty keyring
  	And I import keyfile 2
  	Then I should have 1 public key in the keyring

  Scenario: Exporting a public key
  	Given an empty keyring
  	And a public key
  	And I import keyfile 1
    When I export key <unexpiring.testkey@rugpg.local>
    Then the key should be the same as keyfile 1

  Scenario: Exporting a nonexisting public key
  	Given an empty keyring
  	And a public key
  	And I import keyfile 1
    When I export key <second.unexpiring.testkey@rugpg.local>
    Then the key should be empty
    
  Scenario: Generate a new key
  	Given an empty keyring
  	When I generate a key for user foobar and email foo@bar.com
  	And  I query for public key foo@bar.com
  	Then I should get 1 keys
