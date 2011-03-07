class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
		t.text :login
		t.text :password
		t.text :password_confirmation
		t.text :crypted_password
		t.text :password_salt
		t.text :persistence_token
		t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
