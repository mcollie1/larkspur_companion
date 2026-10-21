class CreateMedications < ActiveRecord::Migration[8.1]
  def change
    create_table :medications do |t|
      t.references :patient, null: false, foreign_key: true

      t.string :name, null: false
      t.string :dosage, null: false
      t.text :instructions

      t.string :frequency_unit, null: false
      t.integer :frequency_interval, null: false, default: 1
      t.integer :doses_per_interval, null: false

      t.string :prescribed_by_name

      t.datetime :started_at, null: false
      t.datetime :ended_at

      t.timestamps
    end

    # add_check_constraint :medications,
    #   "frequency_unit IN ('day', 'week', 'month')",
    #   name: "medications_frequency_unit_allowed"

    # add_check_constraint :medications,
    #   "frequency_interval > 0",
    #   name: "medications_frequency_interval_positive"

    # add_check_constraint :medications,
    #   "doses_per_interval > 0",
    #   name: "medications_doses_per_interval_positive"

    add_index :medications, [ :patient_id, :started_at ], if_not_exists: true
  end
end
