class AddBypassLimitToGolfer < ActiveRecord::Migration[5.2]
  def change
    add_column :golfers, :bypass_limit, :boolean, default: false
  end
end
