class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.uuid :link_id, null: false
      t.string :url, null: false, index: { unique: true }
      t.string :shorter_url, null: false, index: { unique: true }
      t.integer :click_count, null: false, default: 0

      t.timestamps
    end
  end
end
