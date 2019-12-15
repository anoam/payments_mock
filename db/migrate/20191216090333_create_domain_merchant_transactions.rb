class CreateDomainMerchantTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :domain_merchant_transactions do |t|
      t.string :uuid, null: false
      t.decimal :amount
      t.integer :status, null: false, default: 0
      t.index :uuid, unique: true
      t.integer :merchant_id, null: false
      t.integer :base_transaction_id

      t.index :merchant_id
      t.index :base_transaction_id
      t.foreign_key :domain_merchants, column: :merchant_id
      t.timestamps
    end
  end
end
