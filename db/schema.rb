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

ActiveRecord::Schema[7.0].define(version: 2023_06_14_203731) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "archives", force: :cascade do |t|
    t.string "title"
    t.string "path"
    t.string "original_name"
    t.string "type"
    t.string "size"
    t.bigint "report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["report_id"], name: "index_archives_on_report_id"
  end

  create_table "classrooms", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_courses_on_user_id"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string "question_1"
    t.string "question_2"
    t.string "question_3"
    t.string "question_4"
    t.string "question_5"
    t.text "observation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ods_projects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "admin_id", null: false
    t.index ["admin_id"], name: "index_organizations_on_admin_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.string "competency"
    t.string "status"
    t.string "modality"
    t.text "description"
    t.bigint "course_id", null: false
    t.bigint "ods_project_id", null: false
    t.bigint "feedback_id", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["course_id"], name: "index_projects_on_course_id"
    t.index ["feedback_id"], name: "index_projects_on_feedback_id"
    t.index ["ods_project_id"], name: "index_projects_on_ods_project_id"
    t.index ["organization_id"], name: "index_projects_on_organization_id"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "reports", force: :cascade do |t|
    t.float "reported_effort"
    t.date "reported_date"
    t.boolean "status"
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["project_id"], name: "index_reports_on_project_id"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "responsibles", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.boolean "status"
    t.bigint "organization_id", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "is_responsible"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "archives", "reports"
  add_foreign_key "courses", "users"
  add_foreign_key "organizations", "admins"
  add_foreign_key "projects", "courses"
  add_foreign_key "projects", "feedbacks"
  add_foreign_key "projects", "ods_projects"
  add_foreign_key "projects", "organizations"
  add_foreign_key "projects", "users"
  add_foreign_key "reports", "projects"
  add_foreign_key "reports", "users"
  add_foreign_key "users", "organizations"
end
