class CreateCareNotes < ActiveRecord::Migration[8.1]
  def change
    create_table :care_notes do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: { to_table: :users }

      t.references :medication, null: true, foreign_key: true
      t.references :medication_log, null: true, foreign_key: true

      t.text :body

      t.timestamps
    end

    add_index :care_notes, [ :patient_id, :created_at ], if_not_exists: true
  end
end
