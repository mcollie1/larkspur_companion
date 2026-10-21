class CreateCaregiverAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :caregiver_assignments do |t|
      t.references :caregiver, null: false, foreign_key: { to_table: :users }
      t.references :patient, null: false, foreign_key: true
      t.string :relationship
      t.datetime :started_at
      t.datetime :ended_at

      t.timestamps
    end

    add_index :caregiver_assignments,
      [ :caregiver_id, :patient_id ],
      unique: true,
      if_not_exists: true
  end
end
