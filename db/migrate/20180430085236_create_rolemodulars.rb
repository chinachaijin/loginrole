class CreateRolemodulars < ActiveRecord::Migration[5.1]
  def change
    create_table :rolemodulars do |t|
      t.integer :role_id
      t.integer :modularprivilege_id

      t.timestamps
    end
  end
end
