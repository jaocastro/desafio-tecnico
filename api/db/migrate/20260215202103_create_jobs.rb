class CreateJobs < ActiveRecord::Migration[7.2]
  def change
    create_table :jobs do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :status, null: false, default: "draft"
      t.string :location
      t.string :employment_type

      t.timestamps
    end
  end
end
