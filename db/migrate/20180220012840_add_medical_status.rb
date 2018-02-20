class AddMedicalStatus < ActiveRecord::Migration
  def change
    add_column :golfers, :medical_status, :boolean
    add_column :rounds, :medical_status, :boolean
  end
end
