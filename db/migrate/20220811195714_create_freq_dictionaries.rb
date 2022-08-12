class CreateFreqDictionaries < ActiveRecord::Migration[7.0]
  def change
    create_table :freq_dictionaries do |t|
      t.integer :freq_rank
      t.string :word
      t.string :language

      t.timestamps
    end
  end
end
