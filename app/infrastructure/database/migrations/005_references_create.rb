# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:references) do
      primary_key :id
      foreign_key :cve_id, :cves
      String      :link, null: false

      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
