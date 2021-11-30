class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer :correct, default: 0
      t.integer :incorrect, default: 0
      t.integer :total, default: 0
      t.integer :status, default: 0
      t.belongs_to :user
      t.timestamps
    end
  end
end
