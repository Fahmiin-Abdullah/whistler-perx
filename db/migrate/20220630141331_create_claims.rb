class CreateClaims < ActiveRecord::Migration[6.1]
  def change
    create_table :claims do |t|
      t.references :user, null: false, foreign_key: true
      t.references :reward, null: false, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
