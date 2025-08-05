class AddGolfer < ActiveRecord::Migration[7.2]
  def change
    create_table :golfers do |t|
      t.string :first_name
      t.string :last_name
      t.string :identifier
      t.integer :handicap
    end
  end
end
