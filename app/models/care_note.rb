class CareNote < ApplicationRecord
  belongs_to :patient
  belongs_to :author, class_name: "User"

  belongs_to :medication, optional: true
  belongs_to :medication_log, optional: true

  validates :body, presence: true, length: { maximum: 50000 }

  validate :references_belong_to_patient

  private

    def references_belong_to_patient
      if medication && medication.patient_id != patient_id
        errors.add(:medication, "must belong to this patient")
      end

      if medication_log &&
        medication_log.medication.patient_id != patient_id
        errors.add(:medication_log, "must belong to this patient")
      end

      if medication && medication_log &&
        medication_log.medication_id != medication.id
        errors.add(:medication_log, "must belong to the selected medication")
      end
    end
end
