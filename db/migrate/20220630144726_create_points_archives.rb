class CreatePointsArchives < ActiveRecord::Migration[6.1]
  def change
    create_table :points_archives do |t|
      t.references :user, null: false, foreign_key: true
      t.string :year
      t.integer :total

      t.timestamps
    end
  end
end
