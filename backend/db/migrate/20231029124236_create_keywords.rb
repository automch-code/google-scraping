class CreateKeywords < ActiveRecord::Migration[7.0]
  def change
    create_table :keywords do |t|
      t.string  :word
      
      # sort value
      t.integer :adwords
      t.integer :links
      t.decimal :results
      t.decimal :speed
      
      # represent value
      t.string  :rep_adwords
      t.string  :rep_links
      t.string  :rep_results
      t.string  :rep_speed

      t.timestamps
    end

    add_reference :keywords, :user, foreign_key: true, null: true
    add_index :keywords, :word
  end
end
