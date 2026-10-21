# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
#
#
# Create the roles used by the application.
Role::ROLE_TYPES.each do |name|
  Role.find_or_create_by!(name: name)
end

def build_user(email:, first_name:, last_name:)
  user = User.new

  user.first_name = first_name
  user.last_name = last_name
  user.email = email

  user.save!
  user
end

def assign_role!(user, role_name)
  role = Role.find_by!(name: role_name)

  RoleAssignment.find_or_create_by!(
    user: user,
    role: role
  )
end

coordinators = 3.times.map do |i|
  number = i + 1

  user = User.find_or_initialize_by(
    email: "coordinator#{number}@example.test"
  )

  if user.new_record?
    user = build_user(
      email: "coordinator#{number}@example.test",
      first_name: "Coordinator #{number}",
      last_name: "Surname #{number}"
    )
  end

  assign_role!(user, Role::COORDINATOR_ROLE)
  user
end

# Each coordinator receives two patients, with no overlapping caseloads.
patients = 6.times.map do |i|
  number = i + 1

  patient = Patient.find_or_create_by!(
    first_name: "Patient",
    last_name: format("%02d", number)
  ) do |record|
    record.status = "active"
  end

  coordinator = coordinators[i / 2]

  CaseloadAssignment.find_or_create_by!(
    coordinator: coordinator,
    patient: patient
  )

  patient
end

# Optional patient login accounts are not required for these records.
patients.each do |patient|
  medication = Medication.find_or_create_by!(
    patient: patient,
    name: "Demo medication"
  ) do |record|
    record.dosage = "1 tablet"
    record.instructions = "Take as directed."
    record.frequency_unit = "day"
    record.frequency_interval = 1
    record.doses_per_interval = 1
    record.prescribed_by_name = "Demo clinician"
    record.started_at = 30.days.ago
  end

  coordinator = coordinators[patients.index(patient) / 2]

  # One recent missed dose and one taken dose for demonstration.
  [
    {
      status: "missed",
      scheduled_at: 4.hours.ago,
      recorded_at: 3.hours.ago
    },
    {
      status: "taken",
      scheduled_at: 1.day.ago,
      recorded_at: 1.day.ago + 10.minutes
    }
  ].each do |attributes|
    MedicationLog.find_or_create_by!(
      medication: medication,
      scheduled_at: attributes[:scheduled_at]
    ) do |log|
      log.status = attributes[:status]
      log.recorded_at = attributes[:recorded_at]
      log.recorded_by = coordinator
      log.note = "Seeded demo record"
    end
  end

  CareNote.find_or_create_by!(
    patient: patient,
    author: coordinator,
    body: "Initial demo care note."
  )
end

puts "Seeded #{coordinators.size} coordinators and #{patients.size} patients."
