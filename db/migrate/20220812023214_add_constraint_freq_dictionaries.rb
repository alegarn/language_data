class AddConstraintFreqDictionaries < ActiveRecord::Migration[7.0]
  def change
    change_column_null :freq_dictionaries, :freq_rank, false
    change_column_null :freq_dictionaries, :word , false
    change_column_null :freq_dictionaries, :language, false
  end
end
