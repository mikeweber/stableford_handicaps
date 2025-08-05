class AddBypassLimitToGolfer < ActiveRecord::Migration[7.2]
  def change
    add_column :golfers, :bypass_limit, :boolean, default: false
  end
end
