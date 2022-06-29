class CreateFeedbacks < ActiveRecord::Migration[7.0]
  def change
    create_table :feedbacks do |t|
      t.string :project_name
      t.string :description
      t.string :link_project
      t.string :testimoni
      t.integer :rating
      t.references :freelancer, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
