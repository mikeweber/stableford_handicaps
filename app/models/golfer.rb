class Golfer < ActiveRecord::Base
  validates :identifier, presence: true, uniqueness: { unless: ->(golfer) { %w(0 guest).include?(golfer.identifier) }, message: 'A golfer with this member ID already exists in the system' }

  has_many :rounds, dependent: :delete_all

  scope :alphabetized, -> { order('last_name ASC, first_name ASC')}

  def full_name_with_member_id
    "#{full_name} (#{identifier})"
  end

  def full_name
    "#{last_name}, #{first_name}".gsub(/^, |, $/, '')
  end

  def most_recent_round_before(round_date)
    rounds.where(Round.arel_table[:occurred_on].lt(round_date)).first
  end

  def date_of_most_recent_round
    rounds.recent.limit(1).pluck(:occurred_on).first
  end

  def handicap=(hdcp)
    self[:handicap] = limit_handicap(hdcp)
  end

  private

  def limit_handicap(hdcp)
    return if hdcp.blank?

    [26, hdcp.to_i].min
  end
end
