# A new account should be created with an ID and an initial balance
# Should have a withdraw method that accepts a single parameter which represents the amount of money that will be withdrawn. This method should return the updated account balance.
# Should have a deposit method that accepts a single parameter which represents the amount of money that will be deposited. This method should return the updated account balance.
# Should be able to access the current balance of an account at any time.
#

# Bank Account - Wave 1
# Rachel Pavilanis
# August 23, 2016

module Bank

  class Account

    #attr_accessor :id, :balance

    def initialize (account_hash)

      @id = account_hash[:id]
      @balance = account_hash[:balance]

    end

    def check_balance
      return @balance.to_f
    end

    def deposit (deposit_amount)
    end

    def withdraw (withdraw_amount)
    end

account = Account.new("45567", 575.25)
account.check_balance 
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
