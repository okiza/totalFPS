class CreateServers < ActiveRecord::Migration
  def self.up
    create_table :servers do |t|
      t.text :ip
      t.integer :port
      t.text :name

      t.timestamps
    end
  end

  def self.down
    drop_table :servers
  end
end
