
# Bank Account - Wave 1
# Rachel Pavilanis
# August 23, 2016

require 'csv'
require 'awesome_print'

module Bank

# class for bank accounts
  class Account

    attr_accessor :deposit_amount, :withdraw_amount, :owner, :id, :accounts, :open_date, :interest, :fee, :minimum_balance
# initializes bank account with an ID and starting balance, returns Argument Error if proposed starting balance is not at or above 0.
    def initialize (account_hash)
      @id = account_hash[:id]
      @balance = account_hash[:balance]
      @open_date = account_hash[:open_date]
      @owner = Owner.new(account_hash)
      @fee = 0
      @minimum_balance = 0

      if @balance < @minimum_balance
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
      return "Your current balance is $#{@balance}."
    end
# allows deposits to be made, and adds deposit amount to current balance
    def deposit (deposit_amount)
      @balance = deposit_amount.to_f + @balance.to_f
      display_current_balance
    end
# allows withdrawals to be made, and subtracts deposit amount from current balance, unless
# this amount would be less than 0. In that case, an error is returned.
    def withdraw (withdraw_amount)
      withdraw_helper(withdraw_amount, 0, minimum_balance)
    end
# helper method for withdraw
    def withdraw_helper (withdraw_amount, fee, minimum_balance)
      if @balance.to_f - (withdraw_amount.to_f + fee) < minimum_balance
        raise ArgumentError.new("You do not have enough money in account to make that withdrawal. #{display_current_balance}")
      else
        @balance = @balance.to_f - (withdraw_amount.to_f + fee)
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

  attr_accessor :deposit_amount, :withdraw_amount, :owner, :id, :accounts, :open_date, :fee, :minimum_balance
  attr_reader :interest
  # takes functionality from Account class, with exception of minimum balance
  def initialize (account_hash)
    super
    @minimum_balance = 10.00
    @interest
    unless @balance >= 10
      raise ArgumentError.new("You need a balance of at least $10 to open your account.")
    end
  end
  # uses the withdraw_helper class from Account - 2.00 fee for each withdrawal
  def withdraw(withdraw_amount)
    withdraw_helper(withdraw_amount, 2.00, minimum_balance) # calls helper method from parent class (amount, fee, min balance)
  end
# allows deposits to be made, and adds deposit amount to current balance
  def deposit (deposit_amount)
    super
  end
  # adds a calculation for interest rate
  def add_interest(rate)
    interest = @balance.to_f * (rate/100)
    interest = sprintf('%0.2f', interest)
    @balance = interest.to_f + @balance.to_f
    return "You have accumulated $#{interest} of interest on your account."
  end
end

# child class of Account
class CheckingAccount < Account

attr_accessor :deposit_amount, :withdraw_amount, :owner, :id, :accounts, :open_date, :amount, :checks, :days, :fee, :minimum_balance
# used super to copy from parent class, Account, created checks variable
  def initialize (account_hash)
    super
    @checks = 0
  end
# changed fee, used withdraw_helper from parent class
  def withdraw (withdraw_amount)
    withdraw_helper(withdraw_amount, 1.00, 0.00) # calls helper method from parent class (amount, fee, min balance)
  end
# method reset checks at end of every month, emulates time passing
  def reset_checks
      @checks = 0
      return "We have reached the start of a new month - you now have three checks to use for free.  After your first three checks this month, you will incur a fee of 2.00 per check."
  end
# withdraw money from account using check
  def withdraw_using_check(withdraw_amount)
      if checks <= 3
        withdraw_helper(withdraw_amount, 0, -10.00) # calls helper method from parent class (amount, fee, min balance)
        @checks += 1
        display_current_balance
      else
        withdraw_helper(withdraw_amount, 2.00, -10.00) # calls helper method from parent class (amount, fee, min balance)
        @checks += 1
        display_current_balance
      end
  end
# allows deposits to be made, and adds deposit amount to current balance
  def deposit (deposit_amount)
    super
  end
end

# child class of Account
class MoneyMarketAccount < Account

attr_accessor :deposit_amount, :withdraw_amount, :owner, :id, :accounts, :open_date, :amount
attr_reader :maximum_transactions, :minimum_balance, :fee, :transactions

# used super to copy from parent class, Account
  def initialize (account_hash)
    super
    @maximum_transactions = 6
    @transactions = 0
    @minimum_balance = 10000
    if @balance < @minimum_balance
      raise ArgumentError.new("You need a balance above $10,000 to open your account.")
    end
  end
# changed fee/min. balance, used withdraw_helper from parent class
  def withdraw (withdraw_amount)
    if transactions <= 6 && @balance >= minimum_balance
      transactions += 1
      withdraw_helper(withdraw_amount, 0, 10000.00) # calls helper method from parent class (amount, fee, min balance)
    else
      return "You have reached your maximum transactions for the month."
    end
  end
# added add_interest method from SavingsAccount class
  def add_interest(rate)
    super
  end
# users only allowed six transactions a month
  def reset_transactions
    transactions = 0
    return "We have reached the start of a new month - you now have six transactions to use for the month."
  end
# allows deposits to be made, and adds deposit amount to current balance
  def deposit (deposit_amount)
    if transactions <= 6 && @balance >= minimum_balance
      transactions += 1
      super
    elsif @balance < minimum_balance
       super
       if (@balance + deposit_amount) >= minimum_balance
         return "You have made a deposit that puts you above the minimum balance. This transaction will not count against your monthly transactions."
       else
         transactions += 1
         return "Please deposit additional funds to raise your balance above the minimum."
       end
    else
      return "You have reached your maximum transactions for the month."
    end
  end
end


# Updated withdrawal logic:
# If a withdrawal causes the balance to go below $10,000, a fee of $100 is imposed and no more transactions are allowed until the balance is increased using a deposit transaction.



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
# This method should return a collection of Account instances that belong to the specific owner. find method?
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
#
# account = Bank::SavingsAccount.new(id: 45567, balance: 100.00)
#
# ap account.withdraw(5.00)
# ap account.display_current_balance
# ap account.add_interest(0.25)
# ap account.display_current_balance

# account = Bank::CheckingAccount.new(id: 45567, balance: 200.00)
#
# # ap account.withdraw(50.00)
# ap account.withdraw_using_check(50.00)
# ap account.withdraw_using_check(50.00)
# ap account.withdraw_using_check(50.00)
# # ap account.withdraw_using_check(61.00) # try this to make sure min balance/fee works for checking when writing check - works
# ap account.withdraw(50.00) # this tests that min balance/fee works for checking  - works
# ap account.reset_checks # resets checks to 0 if there are more than 3
# ap account.withdraw_using_check(50.00)

moneymarket1 = Bank::MoneyMarketAccount.new(id: 45567, balance: 200.00)



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

#
# account1 = Bank::Account.new(id: "45567", balance: 1000.00, first_name: "Rachel", last_name: "Pavilanis", street_address: "1415 Terminal", city: "Niles", state: "MI", zip: "49120")
# # #
# # # # # account2 = Bank::Account.new(id: "45566", balance: 75.256, first_name: "Matthew", last_name: "Pavilanis", street_address: "2150 McLean", city: "Eugene", state: "OR", zip: "97405")
# # # # #
# puts account1.display_current_balance
# puts account1.deposit(50.65)
# puts account1.withdraw(500.00)
# puts account1.id
# # # puts
# # puts
# ap account1
# #
# puts account2.display_current_balance
# puts account2.deposit(100.00)
# puts account2.withdraw(300.00)
# puts account2
