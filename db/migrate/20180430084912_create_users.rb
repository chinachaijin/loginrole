class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :nickname
      t.integer :sttype
      t.string :session_id
      t.integer :logtype

      t.timestamps
    end
  end
end
