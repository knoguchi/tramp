class Currency < ActiveRecord::Base
  
  @@default_decimal = begin TRAMP[:default_decimal] rescue 2 end
  
  set_table_name :tramp_currencies
  
  attr_readonly :name, :alphabetic_code, :numeric_code, :minor_unit
  
  validates_uniqueness_of :alphabetic_code
  validates_uniqueness_of :numeric_code
  
  CENTS = [0,10,100,1000]
  
  def self.decimal(currency_code)
    case currency_code
    when String
      self.find(:first, :conditions=>["alphabetic_code=?", currency_code]).minor_unit rescue @@default_decimal
    when Numeric
      self.find(:first, :conditions=>["numeric_code=?", currency_code]).minor_unit rescue @@default_decimal
    end
  end
  
  def self.cents_multiplier(currency_code)
    CENTS[decimal(currency_code)]
  end
end

