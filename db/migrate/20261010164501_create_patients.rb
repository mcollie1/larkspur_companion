class CreatePatients < ActiveRecord::Migration[8.1]
  def change
    create_table :patients do |t|
      t.references :user, null: true, foreign_key: true, index: { unique: true }

      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email
      t.string :phone
      t.string :status, null: false, default: "active"

      t.timestamps
    end
  end
end
