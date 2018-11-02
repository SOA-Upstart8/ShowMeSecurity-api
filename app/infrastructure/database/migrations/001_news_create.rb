# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:news) do
      primary_key :id
      String      :source
      String      :title
      String      :url
      String      :image
      String      :time
      String      :content

      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
