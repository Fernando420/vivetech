class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :username, unique: true
      t.string :password_digest
      t.string :email
      t.string :phone
      t.datetime :last_sign_in_at, default: Time.now
      t.integer :sign_in_count, defalut: 0
      t.timestamps
    end
  end
end
