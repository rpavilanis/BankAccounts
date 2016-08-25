
# Bank Account - Wave 1
# Rachel Pavilanis
# August 23, 2016

require 'csv'
require 'awesome_print'

module Bank

# class for bank accounts
  class Account

    attr_accessor :deposit_amount, :withdraw_amount, :owner, :id, :accounts, :open_date
# initializes bank account with an ID and starting balance, returns Argument Error if proposed starting balance is not at or above 0.
    def initialize (account_hash)
      @id = account_hash[:id]
      @balance = account_hash[:balance]
      @open_date = account_hash[:open_date]
      @owner = Owner.new(account_hash)

      unless @balance >= 0
        raise ArgumentError.new("You need a balance above $0 to open your account.")
      end
    end

# class to read in CSV File
    def self.accounts

      @@accounts = []

      account_hash = {}

      CSV.open("support/accounts.csv", 'r').each do |line|
        account_hash[:id] = line[0].to_i
        account_hash[:balance] = line[1].to_f / 100
        account_hash[:open_date] = line[2]
        @@accounts << Bank::Account.new(account_hash)
      end
    end

# formats numbers in a dollar format
    def change_two_decimals
      @balance = sprintf('%0.2f', @balance)  # => "550.50"
    end
# displays the current balance, using the formatting from the change_two_decimals method
    def display_current_balance
      change_two_decimals
      puts "Your current balance is $#{@balance}."
    end
# allows deposits to be made, and adds deposit amount to current balance
    def deposit (deposit_amount)
      @balance = deposit_amount.to_f + @balance.to_f
      display_current_balance
    end
# allows withdrawals to be made, and subtracts deposit amount from current balance, unless
# this amount would be less than 0. In that case, an error is returned.
    def withdraw (withdraw_amount)
      if @balance.to_f - withdraw_amount.to_f < 0
        raise ArgumentError.new("You do not have enough money in account to make that withdrawal.")
        display_current_balance
      else
        @balance = @balance.to_f - withdraw_amount.to_f
        display_current_balance
      end
    end

# returns all accounts when called
    def self.all
      ap @@accounts
    end

# returns an instance of Account where the value of the id field in the CSV matches the passed parameter
    def self.find(id_number)
      @@accounts.each do |account|
        if account.id == id_number
          matching_account = account
          puts "That matches an ID in our system. Here is your account information."
          return ap matching_account
        end
      end
      puts "That ID does not match any accounts in our system."
    end
  end

# child class of account
class SavingsAccount < Account

attr_accessor :deposit_amount, :withdraw_amount, :owner, :id, :accounts, :open_date

def initialize (account_hash)
  super
  unless @balance >= 10
    raise ArgumentError.new("You need a balance of at least $10 to open your account.")
  end

end

  # The initial balance cannot be less than $10. If it is, this will raise an ArgumentError
  # Updated withdrawal functionality:
  # Each withdrawal 'transaction' incurs a fee of $2 that is taken out of the balance.
  # Does not allow the account to go below the $10 minimum balance - Will output a warning message and return the original un-modified balance
  # It should include the following new method:
  #
  # #add_interest(rate): Calculate the interest on the balance and add the interest to the balance. Return the interest that was calculated and added to the balance (not the updated balance).
  # Input rate is assumed to be a percentage (i.e. 0.25).
  # The formula for calculating interest is balance * rate/100
  # Example: If the interest rate is 0.25% and the balance is $10,000, then the interest that is returned is $25 and the new balance becomes $10,025.
end




# class CheckingAccount

# Updated withdrawal functionality:
# Each withdrawal 'transaction' incurs a fee of $1 that is taken out of the balance. Returns the updated account balance.
# Does not allow the account to go negative. Will output a warning message and return the original un-modified balance.
# #withdraw_using_check(amount): The input amount gets taken out of the account as a result of a check withdrawal. Returns the updated account balance.
# Allows the account to go into overdraft up to -$10 but not any lower
# The user is allowed three free check uses in one month, but any subsequent use adds a $2 transaction fee
#reset_checks: Resets the number of checks used to zero
# end













# class for the owners of these bank accounts
  class Owner

    attr_accessor :owner_ID, :first_name, :last_name, :street_address, :city, :state
# initializes user tied to bank account
    def initialize (owner_hash)

      @owner_ID = owner_hash[:owner_ID]
      @first_name = owner_hash[:first_name]
      @last_name = owner_hash[:last_name]
      @address = owner_hash[:street_address]
      @city = owner_hash[:city]
      @state = owner_hash[:state]

    end

# class to read in CSV File
    def self.owners

      @@users = []

      owner_hash = {}

      CSV.open("support/owners.csv", 'r').each do |line|
        owner_hash[:owner_ID] = line[0].to_i
        owner_hash[:first_name] = line[1]
        owner_hash[:last_name] = line[2]
        owner_hash[:street_address] = line[3]
        owner_hash[:city] = line[4]
        owner_hash[:state] = line[5]
        @@users << Bank::Owner.new(owner_hash)
      end
    end

# returns all accounts when called
    def self.all
      ap @@users
    end

# returns an instance of User where the value of the id field in the CSV matches the passed parameter
    def self.find(id_number)
      @@users.each do |user|
        if user.owner_ID == id_number
          matching_account = user
          puts "That matches an ID in our system. Here is your account information."
          return ap matching_account
        end
      end
      puts "That ID does not match any users in our system."
    end

# method to combine users with their accounts
# This method should return a collection of Account instances that belong to the specific owner.
    # def accounts(id)
    #   CSV.open("support/account_owners.csv", "r").each do |line|
    #
    #
    #   end
    #     # be able to find an account and pull it based on owner ID - iterate through owner IDS until it finds
    #     # one you are searching for, and then based on what account ID in line[0] is, find that account (iterate through accounts) and return it
    #
    #
    #
    # end


  end
end

account = Bank::SavingsAccount.new(id: 45567, balance: 9.00)

ap account

# Bank::Account.accounts
# puts
# Bank::Account.all
# puts
# Bank::Account.find(1213)
# puts
# Bank::Account.find(1223)

# Bank::Owner.owners
# puts
# Bank::Owner.all
# puts
# Bank::Owner.find(16)
# puts
# Bank::Owner.find(50)


account1 = Bank::Account.new(id: "45567", balance: -1.00, first_name: "Rachel", last_name: "Pavilanis", street_address: "1415 Terminal", city: "Niles", state: "MI", zip: "49120")
#
# account2 = Bank::Account.new(id: "45566", balance: 75.256, first_name: "Matthew", last_name: "Pavilanis", street_address: "2150 McLean", city: "Eugene", state: "OR", zip: "97405")
#
# puts account.display_current_balance
# puts account.deposit(50.65)
# puts account.withdraw(500.00)
# puts account.id
# puts
# puts
ap account1
#
# puts account2.display_current_balance
# puts account2.deposit(100.00)
# puts account2.withdraw(300.00)
# puts account2
