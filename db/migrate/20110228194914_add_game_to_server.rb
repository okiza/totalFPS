class AddGameToServer < ActiveRecord::Migration
  def self.up
    add_column :servers, :game, :text
  end

  def self.down
    remove_column :servers, :game
  end
end
