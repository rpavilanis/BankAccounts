
# Should have a withdraw method that accepts a single parameter which represents the amount of money that will be withdrawn. This method should return the updated account balance.
# A new account cannot be created with initial negative balance - this will raise an ArgumentError (Google this)
# The withdraw method does not allow the account to go negative - Will output a warning message and return the original un-modified balance
# Bank Account - Wave 1
# Rachel Pavilanis
# August 23, 2016

module Bank

  class Account

    attr_accessor :id, :balance, :deposit_amount, :withdraw_amount

    def initialize (account_hash)
      @id = account_hash[:id]
      @balance = account_hash[:balance]

    end

    def change_two_decimals
      @balance = sprintf('%0.2f', @balance)  # => "550.50"
    end

    def display_current_balance
      change_two_decimals
      puts "Your new balance is $#{@balance}."
    end

    def deposit (deposit_amount)
      @balance = deposit_amount.to_f + @balance.to_f
      display_current_balance

      # user_input functionality
      # puts "How much would you like to deposit today? Please enter a number in dollars and cents (e.g., 58.25)."
      # @deposit_amount = gets.chomp
      # until (@deposit_amount.is_a? Float)
      #   puts "Please try again. Enter a number in dollars and cents."
      #   @deposit_amount = gets.chomp #rescue nil
      # end
    end

    def withdraw (withdraw_amount)
      @balance = @balance.to_f - withdraw_amount.to_f
      display_current_balance
    end

account = Account.new(id: "45567", balance: 575.256)

puts account.display_current_balance
puts account.deposit(50.65)
puts account.withdraw(75.00)




  # class owner
  #
  #   attr_accessor :first_name, :bank_ID, :street_address, :city, :state
  #
  #   def initialize (owner_hash)
  #
  #     @first_name = owner_hash[:first_name],
  #     @bank_ID = owner_hash[:bank_ID],
  #     @address = owner_hash[:street_address],
  #     @city = owner_hash[:city],
  #     @state = owner_hash[:state]
  #
  #   end

  # end
  # end
  #

  end
end
