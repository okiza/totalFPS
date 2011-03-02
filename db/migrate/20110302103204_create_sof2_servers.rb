class CreateSof2Servers < ActiveRecord::Migration
  def self.up
    create_table :sof2_servers do |t|
      t.text :ip
      t.integer :port
      t.text :server_name

      t.timestamps
    end
  end

  def self.down
    drop_table :sof2_servers
  end
end
