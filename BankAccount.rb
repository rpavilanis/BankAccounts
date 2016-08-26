
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

      if @balance < 0
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
      if @balance.to_f - (withdraw_amount.to_f + fee) < minimum_balance
        raise ArgumentError.new("You do not have enough money in account to make that withdrawal. Your current balance is #{display_current_balance}")
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
  # uses the withdraw class from Account - 2.00 fee for each withdrawal
  def withdraw(withdraw_amount)
    @fee = 2.00
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

  def initialize (account_hash)
    super
    @checks = 0
  end

  def withdraw (withdraw_amount)
    @fee = 1.00
    super
  end

  def days_passed
    endDate = Date.new(2016, 1, 1)
    beginDate = Date.new(2016, 1, 3)
    days = beginDate - endDate

    days.to_i
  end

  def reset_checks
    if days_passed > 30
      @checks = 0
    end
  end

  def withdraw_using_check(amount)
    if checks <= 3
      fee = 0.00
    else
      fee = 2.00
    withdraw

    super

    end
  end

      # if (@balance.to_f - amount.to_f) < -10.00
      #   raise ArgumentError.new("You do not have enough money in account to write that check. Your current balance is #{display_current_balance}")
      # else
      #   @balance = @balance.to_f - amount.to_f
      #
      #   @checks = @checks + 1
      #   display_current_balance
      # end
      # reset_checks
      # display_current_balance










# The user is allowed three free check uses in one month, but any subsequent use adds a $2 transaction fee
#reset_checks: Resets the number of checks used to zero
end













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

account = Bank::SavingsAccount.new(id: 45567, balance: 100.00)

ap account.withdraw(5.00)
ap account.display_current_balance
ap account.add_interest(0.25)
ap account.display_current_balance

account = Bank::CheckingAccount.new(id: 45567, balance: 300.00)

ap account.withdraw(50.00)
# ap account.withdraw_using_check(50.00)
# ap account.withdraw_using_check(50.00)
# ap account.withdraw_using_check(50.00)
# ap account.days_passed




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


# account1 = Bank::Account.new(id: "45567", balance: -1.00, first_name: "Rachel", last_name: "Pavilanis", street_address: "1415 Terminal", city: "Niles", state: "MI", zip: "49120")
# #
# # account2 = Bank::Account.new(id: "45566", balance: 75.256, first_name: "Matthew", last_name: "Pavilanis", street_address: "2150 McLean", city: "Eugene", state: "OR", zip: "97405")
# #
# # puts account.display_current_balance
# # puts account.deposit(50.65)
# # puts account.withdraw(500.00)
# # puts account.id
# # puts
# # puts
# ap account1
# #
# puts account2.display_current_balance
# puts account2.deposit(100.00)
# puts account2.withdraw(300.00)
# puts account2
