class CreateUserManagementUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :user_management_users do |t|
      t.string :type
      t.string :email
      t.string :encrypted_password
      t.string :token
      t.integer :domain_merchant_id

      t.foreign_key :domain_merchants, column: :domain_merchant_id
      t.index :token, unique: true
      t.timestamps
    end
  end
end
