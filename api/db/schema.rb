ActiveRecord::Schema[7.2].define(version: 2026_02_15_202103) do
  enable_extension "plpgsql"

  create_table "jobs", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.string "status", default: "draft", null: false
    t.string "location"
    t.string "employment_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
