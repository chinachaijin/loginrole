class CreateModulars < ActiveRecord::Migration[5.1]
  def change
    create_table :modulars do |t|
      t.string :name
      t.string :displyname

      t.timestamps
    end
  end
end
