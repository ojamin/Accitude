class ChangeDescOnItem < ActiveRecord::Migration
  def self.up
    change_column :items, :desc, :string
  end

  def self.down
    change_column :items, :desc, :text
  end
end
