
# Should have a withdraw method that accepts a single parameter which represents the amount of money that will be withdrawn. This method should return the updated account balance.
# Should have a deposit method that accepts a single parameter which represents the amount of money that will be deposited. This method should return the updated account balance.

# Bank Account - Wave 1
# Rachel Pavilanis
# August 23, 2016

module Bank

  class Account

    attr_reader :id, :balance

    def initialize (account_hash)
      @id = account_hash[:id]
      @balance = account_hash[:balance]
    end

    def change_two_decimals
      @balance = sprintf('%0.2f', @balance)  # => "550.50"
    end

    def check_balance
      change_two_decimals
      puts "Your new balance is $#{@balance}."
    end

    def deposit
      puts "How much would you like to deposit today? Please enter a number in dollars and cents (e.g., 58.25)."
      @deposit_amount = gets.chomp
      until (@deposit_amount.is_a? Float)
        puts "Please try again. Enter a number in dollars and cents."
        @deposit_amount = gets.chomp rescue nil
      end

      @balance = @deposit_amount.to_f + @balance.to_f

      check_balance

    end

    def withdraw (withdraw_amount)

      check_balance
    end

account = Account.new(id: "45567", balance: 575.256)

puts account.check_balance
puts account.deposit




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
