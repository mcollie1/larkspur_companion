class CreateCaseloadAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :caseload_assignments do |t|
      t.references :coordinator,
                   null: false,
                   foreign_key: { to_table: :users }

      t.references :patient,
                    null: false,
                    foreign_key: true

      t.timestamps
    end

    add_index :caseload_assignments,
              [ :coordinator_id, :patient_id ],
              unique: true,
              if_not_exists: true
  end
end
