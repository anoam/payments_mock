class CreateDomainMerchants < ActiveRecord::Migration[6.0]
  def change
    create_table :domain_merchants do |t|
      t.string :name
      t.string :email, null: false
      t.text :description
      t.integer :status, null: false, default: 0
      t.decimal :transaction_sum

      t.index :email, unique: true
      t.timestamps
    end
  end
end
