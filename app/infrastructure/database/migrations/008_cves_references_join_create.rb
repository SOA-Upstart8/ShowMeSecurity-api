# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:cves_references) do
      primary_key %i[cve_id reference_id]
      foreign_key :cve_id, :cves
      foreign_key :reference_id, :references

      index %i[cve_id reference_id]
    end
  end
end
