class Round < ActiveRecord::Base
  belongs_to :golfer

  validates :golfer, :occurred_on, :gross_score, :handicap, presence: true

  scope :recent, -> { ordered_by_recent.limit(10) }
  scope :ordered_by_recent, -> { order(arel_table[:occurred_on].desc) }

  def self.recent_dates(limit = 5)
    group(:occurred_on).order('occurred_on desc').limit(limit).pluck('occurred_on, count(*) as num')
  end

  def self.for_date(occurred_on)
    occurred_on ||= max_date
    [where(arel_table[:occurred_on].eq(occurred_on)).includes(:golfer), as_date(occurred_on)]
  end

  def self.max_date
    self.pluck(self.arel_table[:occurred_on].maximum.to_sql).first
  end

  def self.as_date(date)
    return date if date.is_a?(Date)
    Date.parse(date)
  end

  def net_score(current_handicap = handicap)
    return nil if gross_score.blank?
    gross_score + current_handicap.to_i
  end

  def net_score=(score)
    self.gross_score = score.to_i - handicap.to_i
  end
end
