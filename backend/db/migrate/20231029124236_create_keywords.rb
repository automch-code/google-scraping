class CreateKeywords < ActiveRecord::Migration[7.0]
  def change
    create_table :keywords do |t|
      t.string  :word
      
      # sort value
      t.integer :adwords, default: 0
      t.integer :links,   default: 0
      t.decimal :results, default: 0
      t.decimal :speed,   default: 0
      
      # represent value
      t.string  :rep_adwords, default: ''
      t.string  :rep_links,   default: ''
      t.string  :rep_results, default: ''
      t.string  :rep_speed,   default: ''

      # html text
      t.text    :html_text,   default: ''
      t.integer :status,  default: 0

      t.timestamps
    end

    add_reference :keywords, :user, foreign_key: true, null: true
  end
end
