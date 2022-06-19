class CreateClients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :phone
      t.date :date_birth
      t.string :type_industry
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
