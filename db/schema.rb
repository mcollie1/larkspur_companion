# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_10_10_172012) do
  create_table "care_notes", force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "author_id", null: false
    t.integer "medication_id"
    t.integer "medication_log_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_care_notes_on_author_id"
    t.index ["medication_id"], name: "index_care_notes_on_medication_id"
    t.index ["medication_log_id"], name: "index_care_notes_on_medication_log_id"
    t.index ["patient_id", "created_at"], name: "index_care_notes_on_patient_id_and_created_at"
    t.index ["patient_id"], name: "index_care_notes_on_patient_id"
  end

  create_table "caregiver_assignments", force: :cascade do |t|
    t.integer "caregiver_id", null: false
    t.integer "patient_id", null: false
    t.string "relationship"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["caregiver_id", "patient_id"], name: "index_caregiver_assignments_on_caregiver_id_and_patient_id", unique: true
    t.index ["caregiver_id"], name: "index_caregiver_assignments_on_caregiver_id"
    t.index ["patient_id"], name: "index_caregiver_assignments_on_patient_id"
  end

  create_table "caseload_assignments", force: :cascade do |t|
    t.integer "coordinator_id", null: false
    t.integer "patient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coordinator_id", "patient_id"], name: "index_caseload_assignments_on_coordinator_id_and_patient_id", unique: true
    t.index ["coordinator_id"], name: "index_caseload_assignments_on_coordinator_id"
    t.index ["patient_id"], name: "index_caseload_assignments_on_patient_id"
  end

  create_table "medication_logs", force: :cascade do |t|
    t.integer "medication_id", null: false
    t.integer "recorded_by_id", null: false
    t.string "status", null: false
    t.datetime "scheduled_at", null: false
    t.datetime "recorded_at", null: false
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medication_id", "recorded_at"], name: "index_medication_logs_on_medication_id_and_recorded_at"
    t.index ["medication_id", "scheduled_at"], name: "index_medication_logs_on_medication_id_and_scheduled_at", unique: true
    t.index ["medication_id"], name: "index_medication_logs_on_medication_id"
    t.index ["recorded_by_id"], name: "index_medication_logs_on_recorded_by_id"
    t.index ["status", "recorded_at"], name: "index_medication_logs_on_status_and_recorded_at"
  end

  create_table "medications", force: :cascade do |t|
    t.integer "patient_id", null: false
    t.string "name", null: false
    t.string "dosage", null: false
    t.text "instructions"
    t.string "frequency_unit", null: false
    t.integer "frequency_interval", default: 1, null: false
    t.integer "doses_per_interval", null: false
    t.string "prescribed_by_name"
    t.datetime "started_at", null: false
    t.datetime "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id", "started_at"], name: "index_medications_on_patient_id_and_started_at"
    t.index ["patient_id"], name: "index_medications_on_patient_id"
  end

  create_table "patients", force: :cascade do |t|
    t.integer "user_id"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email"
    t.string "phone"
    t.string "status", default: "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_patients_on_user_id", unique: true
  end

  create_table "role_assignments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_role_assignments_on_role_id"
    t.index ["user_id", "role_id"], name: "index_role_assignments_on_user_id_and_role_id", unique: true
    t.index ["user_id"], name: "index_role_assignments_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "care_notes", "medication_logs"
  add_foreign_key "care_notes", "medications"
  add_foreign_key "care_notes", "patients"
  add_foreign_key "care_notes", "users", column: "author_id"
  add_foreign_key "caregiver_assignments", "patients"
  add_foreign_key "caregiver_assignments", "users", column: "caregiver_id"
  add_foreign_key "caseload_assignments", "patients"
  add_foreign_key "caseload_assignments", "users", column: "coordinator_id"
  add_foreign_key "medication_logs", "medications"
  add_foreign_key "medication_logs", "users", column: "recorded_by_id"
  add_foreign_key "medications", "patients"
  add_foreign_key "patients", "users"
  add_foreign_key "role_assignments", "roles"
  add_foreign_key "role_assignments", "users"
end
