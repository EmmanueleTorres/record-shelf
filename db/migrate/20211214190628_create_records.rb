class CreateRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :records do |t|
      t.string :title
      t.string :artist
      t.string :img_url
      t.string :catalog_number
      t.string :release_format
      t.string :release_year
      t.string :release_country
      t.string :labels

      t.timestamps
    end
  end
end
