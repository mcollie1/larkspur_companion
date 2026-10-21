class CaregiverAssignment < ApplicationRecord
  belongs_to :caregiver, class_name: "User"
  belongs_to :patient

  validates :patient_id, uniqueness: { scope: :caregiver_id }
end
