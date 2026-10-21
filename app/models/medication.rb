class Medication < ApplicationRecord
  DAY_FREQUENCY = "day".freeze
  WEEK_FREQUENCY = "week".freeze
  MONTH_FREQUENCY = "month".freeze

  FREQUENCY_UNITS = [ DAY_FREQUENCY, WEEK_FREQUENCY, MONTH_FREQUENCY ].freeze

  belongs_to :patient

  has_many :medication_logs,
           dependent: :restrict_with_error

  validates :name, :dosage, :started_at, presence: true, length: { maximum: 300 }

  validates :frequency_unit,
            inclusion: { in: FREQUENCY_UNITS }

  validates :frequency_interval,
            numericality: { only_integer: true, greater_than: 0 }

  validates :doses_per_interval,
            numericality: { only_integer: true, greater_than: 0 }

  validate :ended_at_after_started_at

  private

    def ended_at_after_started_at
      return unless started_at && ended_at
      return if ended_at >= started_at

      errors.add(:ended_at, "must be on or after the start time")
    end
end
