class Round < ActiveRecord::Base
  belongs_to :golfer

  validates :golfer, :occurred_on, :gross_score, :handicap, presence: true

  scope :recent, -> { order('occurred_on DESC').limit(10) }

  def net_score(current_handicap = handicap)
    return nil if gross_score.blank?
    gross_score + current_handicap.to_i
  end

  def net_score=(score)
    self.gross_score = score.to_i - handicap.to_i
  end
end