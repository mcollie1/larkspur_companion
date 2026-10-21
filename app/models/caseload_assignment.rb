class CaseloadAssignment < ApplicationRecord
  belongs_to :coordinator, class_name: "User"
  belongs_to :patient

  validates :patient_id, uniqueness: { scope: :coordinator_id }
end
