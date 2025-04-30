class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string  :name,  null: false
      t.text    :description
      t.decimal :price, precision: 10, scale: 2,
                        null: false, default: 0.0
      t.boolean :active, null: false, default: true
      t.references :user,     null: false, foreign_key: true
      t.references :category,               foreign_key: true
      t.timestamps
    end

    add_index :products, %i[user_id name], unique: true
  end
end
