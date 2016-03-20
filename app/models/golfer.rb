class Golfer < ActiveRecord::Base
  validates :identifier, presence: true, uniqueness: { unless: ->(golfer) { %w(0 guest).include?(golfer.identifier) }, message: 'A golfer with this member ID already exists in the system' }

  has_many :rounds

  scope :alphabetized, -> { order('last_name ASC, first_name ASC')}

  def full_name_with_member_id
    "#{full_name} (#{identifier})"
  end

  def full_name
    "#{last_name}, #{first_name}"
  end

  def date_of_most_recent_round
    rounds.recent.limit(1).pluck(:occurred_on).first
  end
end
