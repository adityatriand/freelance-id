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

ActiveRecord::Schema[7.0].define(version: 2022_06_29_063915) do
  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.date "date_birth"
    t.string "type_industry"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_clients_on_user_id"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string "project_name"
    t.string "description"
    t.string "link_project"
    t.string "testimoni"
    t.integer "rating"
    t.integer "freelancer_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["freelancer_id"], name: "index_feedbacks_on_freelancer_id"
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "freelancers", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.date "date_birth"
    t.string "category_work"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_freelancers_on_user_id"
  end

  create_table "portofolios", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "type_project"
    t.string "client_name"
    t.string "client_industry"
    t.string "link_url"
    t.string "porto_attachment"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_portofolios_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "clients", "users"
  add_foreign_key "feedbacks", "freelancers"
  add_foreign_key "feedbacks", "users"
  add_foreign_key "freelancers", "users"
  add_foreign_key "portofolios", "users"
end
