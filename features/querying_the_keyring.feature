Feature: Querying the GnuPG keyring
  In order to to be able to work with GnuPG Keys
  I should be able to
  Query the keyring

  Scenario: List public keys in an empty keyring
    Given an empty keyring
    When I list public keys
    Then I should get 0 keys

  Scenario: List secret keys in an empty keyring
    Given an empty keyring
    When I list secret keys
    Then I should get 0 keys

  Scenario: List all keys in an empty keyring
    Given an empty keyring
    When I list all keys
    Then I should get 0 keys
  
  Scenario: List a filled keyring
    Given a keyring with 2 keys
    When I list public keys
    Then I should get 2 keys

  Scenario: List a public keys on a keyring with private keys
  	Given a keyring with 2 keys
  	And 1 secret key
  	When I list public keys
  	Then I should get 2 keys  

  Scenario: List a secret keys on a keyring with private keys
  	Given a keyring with 2 keys
  	And 1 secret key
  	When I list secret keys
  	Then I should get 1 keys

  Scenario: Query an existing public key in a keyring
  	Given a keyring with 1 keys
  	When I query for public key unexpiring.testkey@rugpg.local
  	Then I should get 1 keys

  Scenario: Query an existing public key in a keyring with a strict pattern
  	Given a keyring with 1 keys
  	When I query for public key <unexpiring.testkey@rugpg.local>
  	Then I should get 1 keys

  Scenario: Query an inexisting public key in a keyring
  	Given a keyring with 1 keys
  	When I query for public key foobar
  	Then I should get 0 keys

  Scenario: Query an inexisting secret key in a keyring
  	Given a keyring with 1 keys
  	When I query for public key foobar
  	Then I should get 0 keys
  	
  Scenario: Query an existing secret key in a keyring
  	Given a keyring with 0 keys
  	And 1 secret key
  	When I query for secret key second.unexpiring.testkey@rugpg.local
  	Then I should get 0 keys
  	
  Scenario: Check for existing secret key in a keyring
  	Given a keyring with 1 keys
  	And 1 secret key
  	When I check for secret key unexpiring.testkey@rugpg.local
  	Then it should be found

  Scenario: Check for inexisting secret key in a keyring
  	Given a keyring with 1 keys
  	When I check for secret key foobar
  	Then it should not be found
  	
  Scenario: Check for existing public key in a keyring
  	Given a keyring with 1 keys
  	When I check for public key unexpiring.testkey@rugpg.local
  	Then it should be found
  	
  Scenario: Check for public key in a keyring
  	Given a keyring with 1 keys
  	When I check for public key second.unexpiring.testkey@rugpg.local
  	Then it should not be found
  	
  Scenario: Check strict on email-address lookups
  	Given an empty keyring
  	And I import keyfile 2
  	When I check for public key unexpiring.testkey@rugpg.local
  	Then it should not be found
  	
  Scenario: Check weakly on email-address lookups
  	Given an empty keyring
  	And I import keyfile 2
  	When I check for public key unexpiring.testkey@rugpg.local weakly
  	Then it should be found

  Scenario: Get the exact key on empty keyring
  	Given an empty keyring
  	When I get exactly the public key unexpiring.testkey@rugpg.local
  	Then I should get 0 keys
  	
  Scenario: Get the exact key on wrong keyring
  	Given an empty keyring
  	And I import keyfile 2
  	When I get exactly the public key unexpiring.testkey@rugpg.local
  	Then I should get 0 keys
  	
  Scenario: Get the exact key on good keyring
  	Given an empty keyring
  	And I import keyfile 1
  	When I get exactly the public key unexpiring.testkey@rugpg.local
  	Then I should get 1 keys
  	And the email should be unexpiring.testkey@rugpg.local

  Scenario: Get the exact key on bad keyring
  	Given an empty keyring
  	And I import keyfile 2
  	And I import keyfile 2old
  	When I get exactly the public key unexpiring.testkey@rugpg.local
  	Then I should get 0 keys