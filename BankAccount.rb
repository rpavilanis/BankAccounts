
# Bank Account - Wave 1
# Rachel Pavilanis
# August 23, 2016

module Bank

# class for bank accounts
  class Account

    attr_accessor :deposit_amount, :withdraw_amount, :owner, :id
# initializes bank account with an ID and starting balance, returns Argument Error if proposed starting balance is not at or above 0.
    def initialize (account_hash)
      @id = account_hash[:id]
      @balance = account_hash[:balance]
      @owner = Owner.new(account_hash)

      unless @balance >= 0
        raise ArgumentError.new("You need a balance above $0 to open your account.")
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
  end

# class for the owners of these bank accounts
  class Owner

    attr_accessor :first_name, :last_name, :street_address, :city, :state, :zip
# initializes user tied to bank account
    def initialize (owner_hash)

      @first_name = owner_hash[:first_name]
      @last_name = owner_hash[:last_name]
      @address = owner_hash[:street_address]
      @city = owner_hash[:city]
      @state = owner_hash[:state]
      @zip = owner_hash[:zip]

    end
  end
end

account = Bank::Account.new(id: "45567", balance: 575.256, first_name: "Rachel", last_name: "Pavilanis", street_address: "1415 Terminal", city: "Niles", state: "MI", zip: "49120")

account2 = Bank::Account.new(id: "45566", balance: 75.256, first_name: "Matthew", last_name: "Pavilanis", street_address: "2150 McLean", city: "Eugene", state: "OR", zip: "97405")

puts account.display_current_balance
puts account.deposit(50.65)
puts account.withdraw(500.00)
puts account.id

puts account2.display_current_balance
puts account2.deposit(100.00)
puts account2.withdraw(300.00)
