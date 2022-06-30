class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.date :birthdate
      t.integer :points_cached, default: 0
      t.string :tier, default: 'standard'

      t.timestamps
    end
  end
end
