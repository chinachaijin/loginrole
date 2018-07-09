class CreateModularprivileges < ActiveRecord::Migration[5.1]
  def change
    create_table :modularprivileges do |t|
      t.integer :modular_id
      t.integer :privilege_id
      t.string :name

      t.timestamps
    end
  end
end
