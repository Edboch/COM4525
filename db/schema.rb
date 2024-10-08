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

ActiveRecord::Schema[7.1].define(version: 2024_05_09_185749) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "invites", force: :cascade do |t|
    t.datetime "time"
    t.string "location"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id", null: false
    t.index ["team_id"], name: "index_invites_on_team_id"
  end

  create_table "landing_page_views", force: :cascade do |t|
    t.bigint "landing_page_id"
    t.datetime "visit_at", null: false
    t.decimal "view_duration", default: "0.0", null: false
    t.bigint "landing_viewer_id"
    t.index ["landing_page_id"], name: "index_landing_page_views_on_landing_page_id"
  end

  create_table "landing_pages", force: :cascade do |t|
    t.string "page_name", null: false
  end

  create_table "landing_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "latitude", default: "0.0", null: false
    t.decimal "longitude", default: "0.0", null: false
    t.index ["email"], name: "index_landing_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_landing_users_on_reset_password_token", unique: true
  end

  create_table "landing_viewers", force: :cascade do |t|
    t.bigint "landing_user_id"
    t.integer "selected_plan", default: 0, null: false
    t.index ["landing_user_id"], name: "index_landing_viewers_on_landing_user_id"
  end

  create_table "landing_visitor_locations", force: :cascade do |t|
    t.decimal "latitude", default: "0.0", null: false
    t.decimal "longitude", default: "0.0", null: false
  end

  create_table "like_answers", force: :cascade do |t|
    t.bigint "landing_user_id", null: false
    t.bigint "question_answer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["landing_user_id"], name: "index_like_answers_on_landing_user_id"
    t.index ["question_answer_id"], name: "index_like_answers_on_question_answer_id"
  end

  create_table "like_reviews", force: :cascade do |t|
    t.bigint "review_id", null: false
    t.bigint "landing_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["landing_user_id"], name: "index_like_reviews_on_landing_user_id"
    t.index ["review_id"], name: "index_like_reviews_on_review_id"
  end

  create_table "match_events", force: :cascade do |t|
    t.bigint "match_id", null: false
    t.bigint "user_id", null: false
    t.integer "event_type"
    t.integer "event_minute"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_match_events_on_match_id"
    t.index ["user_id"], name: "index_match_events_on_user_id"
  end

  create_table "matches", force: :cascade do |t|
    t.string "location", null: false
    t.string "opposition", null: false
    t.datetime "start_time", null: false
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "goals_for"
    t.integer "goals_against"
    t.bigint "team_id", default: 1, null: false
    t.index ["team_id"], name: "index_matches_on_team_id"
  end

  create_table "page_to_page_step_counts", force: :cascade do |t|
    t.bigint "landing_page_id_from", null: false
    t.bigint "landing_page_id_to", null: false
    t.integer "count", default: 0, null: false
  end

  create_table "penultimate_page_counts", force: :cascade do |t|
    t.bigint "landing_page_id", null: false
    t.integer "count", default: 0, null: false
  end

  create_table "player_matches", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "match_id", null: false
    t.integer "position", default: 0
    t.boolean "available", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_player_matches_on_match_id"
    t.index ["user_id"], name: "index_player_matches_on_user_id"
  end

  create_table "player_ratings", force: :cascade do |t|
    t.bigint "match_id", null: false
    t.bigint "user_id", null: false
    t.integer "rating", default: -1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_player_ratings_on_match_id"
    t.index ["user_id"], name: "index_player_ratings_on_user_id"
  end

  create_table "question_answers", force: :cascade do |t|
    t.string "question", null: false
    t.string "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "show", default: false, null: false
    t.integer "clicks", default: 0, null: false
  end

  create_table "reports", force: :cascade do |t|
    t.bigint "user_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "solved", default: false
  end

  create_table "reviews", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "experience"
    t.boolean "visibility"
    t.integer "likes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "display_priority", limit: 2, default: 1, null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "site_admins", force: :cascade do |t|
    t.bigint "user_id"
    t.index ["user_id"], name: "index_site_admins_on_user_id", unique: true
  end

  create_table "site_visit_groupings", force: :cascade do |t|
    t.string "category", null: false
    t.integer "count", default: 0, null: false
    t.datetime "period_start"
  end

  create_table "site_visits", force: :cascade do |t|
    t.datetime "visit_start"
    t.datetime "visit_end"
  end

  create_table "team_activities", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.integer "active_users", default: 0, null: false
    t.datetime "day_start", null: false
    t.index ["team_id"], name: "index_team_activities_on_team_id"
  end

  create_table "team_roles", force: :cascade do |t|
    t.string "name", null: false
    t.integer "type"
  end

  create_table "teams", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "location_name"
    t.bigint "owner_id"
    t.string "url"
    t.string "team_name"
  end

  create_table "user_team_roles", id: false, force: :cascade do |t|
    t.bigint "user_team_id", null: false
    t.bigint "team_role_id", null: false
    t.index ["team_role_id"], name: "index_user_team_roles_on_team_role_id"
    t.index ["user_team_id"], name: "index_user_team_roles_on_user_team_id"
  end

  create_table "user_teams", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "accepted", default: false
    t.index ["team_id"], name: "index_user_teams_on_team_id"
    t.index ["user_id"], name: "index_user_teams_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "invites", "teams"
  add_foreign_key "like_answers", "landing_users"
  add_foreign_key "like_answers", "question_answers"
  add_foreign_key "like_reviews", "landing_users"
  add_foreign_key "like_reviews", "reviews"
  add_foreign_key "match_events", "matches"
  add_foreign_key "match_events", "users"
  add_foreign_key "matches", "teams"
  add_foreign_key "player_matches", "matches"
  add_foreign_key "player_matches", "users"
  add_foreign_key "player_ratings", "matches"
  add_foreign_key "player_ratings", "users"
  add_foreign_key "site_admins", "users"
  add_foreign_key "team_activities", "teams"
  add_foreign_key "user_teams", "teams"
  add_foreign_key "user_teams", "users"
end
