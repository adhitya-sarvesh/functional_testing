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

ActiveRecord::Schema.define(version: 20180226081738) do

  create_table "associates", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.index ["id"], name: "sqlite_autoindex_associates_1", unique: true
  end

  create_table "associates_solutions", id: false, force: :cascade do |t|
    t.integer "solution_id", null: false
    t.string "associate_id"
    t.index ["associate_id", "solution_id"], name: "index_associates_solutions_on_associate_id_and_solution_id"
    t.index ["solution_id", "associate_id"], name: "index_associates_solutions_on_solution_id_and_associate_id"
  end

  create_table "parameters", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.integer "scenario_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["scenario_id"], name: "index_parameters_on_scenario_id"
  end

  create_table "requests", id: :string, force: :cascade do |t|
    t.text "tags"
    t.string "status"
    t.text "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description", limit: 500
    t.integer "solution_id"
    t.index ["id"], name: "sqlite_autoindex_requests_1", unique: true
  end

  create_table "scenario_steps", force: :cascade do |t|
    t.string "scenario_id"
    t.string "step_type"
    t.text "step_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scenarios", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description", limit: 300
    t.string "created_by"
    t.string "updated_by"
    t.integer "solution_id"
  end

  create_table "scenarios_workflows", force: :cascade do |t|
    t.integer "scenario_id"
    t.integer "workflow_id"
    t.index ["scenario_id"], name: "index_scenarios_workflows_on_scenario_id"
    t.index ["workflow_id"], name: "index_scenarios_workflows_on_workflow_id"
  end

  create_table "solution_configurations", force: :cascade do |t|
    t.integer "solution_id"
    t.text "key"
    t.text "value"
  end

  create_table "solutions", force: :cascade do |t|
    t.string "name"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "workflows", force: :cascade do |t|
    t.string "name"
    t.string "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
