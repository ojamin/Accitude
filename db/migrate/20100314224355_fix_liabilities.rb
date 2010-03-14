class FixLiabilities < ActiveRecord::Migration
  def self.up
    AllLiability.find(:all).each {|i|
      i[:type] = "Liability"
      i.save
    }
  end

  def self.down
  end
end
