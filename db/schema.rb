# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160121020117) do

  create_table "recipe_ingredients", force: :cascade do |t|
    t.integer  "recipe_id"
    t.string   "name"
    t.string   "quantity_for"
    t.integer  "row_order"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "recipe_ingredients", ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id"

  create_table "recipe_steps", force: :cascade do |t|
    t.integer  "recipe_id"
    t.string   "text"
    t.string   "photo_url"
    t.integer  "row_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "image"
  end

  add_index "recipe_steps", ["recipe_id"], name: "index_recipe_steps_on_recipe_id"

  create_table "recipes", force: :cascade do |t|
    t.string   "title"
    t.string   "author_name"
    t.string   "ref_url"
    t.string   "main_photo_url"
    t.string   "description"
    t.string   "servings_for"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "image"
    t.integer  "user_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "email",                        null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token"

end
