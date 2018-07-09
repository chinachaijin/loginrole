class CreateUserpwds < ActiveRecord::Migration[5.1]
  def change
    create_table :userpwds do |t|
      t.integer :user_id
      t.string :password_digest
      t.datetime :uptime
      t.integer :errpwd
      t.integer :nids

      t.timestamps
    end
  end
end
