class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.string :name
      t.string :remark
      t.integer :sttype
      t.integer :up_id

      t.timestamps
    end
  end
end
