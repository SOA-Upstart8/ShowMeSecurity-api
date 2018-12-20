# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:owasp_refs) do
      primary_key :id
      foreign_key :cve_id, :owasps
      String      :link, null: false
      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
