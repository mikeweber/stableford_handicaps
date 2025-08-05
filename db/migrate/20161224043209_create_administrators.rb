class CreateAdministrators < ActiveRecord::Migration[7.2]
  def change
    create_table :administrators do |t|
      t.string :email
      t.string :password_digest
    end
  end
end
