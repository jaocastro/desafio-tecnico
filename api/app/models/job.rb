class Job < ApplicationRecord
  STATUSES = %w[draft published].freeze
  EMPLOYMENT_TYPES = %w[clt pj internship].freeze

  validates :title, presence: true, length: { minimum: 3 }
  validates :description, presence: true, length: { minimum: 30 }
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :employment_type, inclusion: { in: EMPLOYMENT_TYPES }, allow_blank: true
end
