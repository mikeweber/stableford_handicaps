class Round < ActiveRecord::Base
  belongs_to :golfer

  validates :golfer, :occurred_on, :gross_score, :handicap, presence: true

  scope :recent, -> { ordered_by_recent.limit(10) }
  scope :ordered_by_recent, -> { order(arel_table[:occurred_on].desc) }

  def net_score(current_handicap = handicap)
    return nil if gross_score.blank?
    gross_score + current_handicap.to_i
  end

  def net_score=(score)
    self.gross_score = score.to_i - handicap.to_i
  end
end
