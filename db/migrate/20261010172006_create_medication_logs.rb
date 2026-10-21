class CreateMedicationLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :medication_logs do |t|
      t.references :medication, null: false, foreign_key: true
      t.references :recorded_by, null: false, foreign_key: { to_table: :users }

      t.string :status, null: false
      t.datetime :scheduled_at, null: false
      t.datetime :recorded_at, null: false

      t.text :note

      t.timestamps
    end

    add_index :medication_logs,
      [ :medication_id, :scheduled_at ],
      unique: true,
      if_not_exists: true

    add_index :medication_logs,
      [ :medication_id, :recorded_at ],
      if_not_exists: true


    add_index :medication_logs,
      [ :status, :recorded_at ],
      if_not_exists: true
  end
end
