# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_08_12_023214) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "freq_dictionaries", force: :cascade do |t|
    t.integer "freq_rank"
    t.string "word"
    t.string "language"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "track_score_freq_dictionaries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "track_score_id"
    t.bigint "freq_dictionary_id"
    t.index ["freq_dictionary_id"], name: "index_track_score_freq_dictionaries_on_freq_dictionary_id"
    t.index ["track_score_id"], name: "index_track_score_freq_dictionaries_on_track_score_id"
  end

  create_table "track_scores", force: :cascade do |t|
    t.integer "track_word_occurence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "track_id"
    t.index ["track_id"], name: "index_track_scores_on_track_id"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "title"
    t.string "song_type"
    t.string "band"
    t.string "album"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "track_score_freq_dictionaries", "freq_dictionaries"
  add_foreign_key "track_score_freq_dictionaries", "track_scores"
  add_foreign_key "track_scores", "tracks"
end