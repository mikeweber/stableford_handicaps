class AddRound < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.integer :golfer_id
      t.integer :gross_score
      t.integer :handicap
      t.date :occurred_on
    end
  end
end
