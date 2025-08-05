class AddMedicalStatus < ActiveRecord::Migration[7.2]
  def change
    add_column :golfers, :medical_status, :boolean
    add_column :rounds, :medical_status, :boolean
  end
end
