# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:experts) do
      primary_key :id
      Integer     :user_id, unique: true, null: false
      String      :image
      Integer     :follower_count
      String      :name
      String      :user_page

      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
