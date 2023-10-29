class CreateImportHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :import_histories do |t|
      t.string :filename

      t.timestamps
    end

    add_reference :import_histories, :user, foreign_key: true, null: true
  end
end
