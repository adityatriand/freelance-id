class CreatePortofolios < ActiveRecord::Migration[7.0]
  def change
    create_table :portofolios do |t|
      t.string :title
      t.string :description
      t.string :type_project
      t.string :client_name
      t.string :client_industry
      t.string :link_url
      t.string :porto_attachment
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
