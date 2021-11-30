class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.integer :correct, default: 0
      t.integer :incorrect, default: 0
      t.integer :total, default: 0
      t.belongs_to :user
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
