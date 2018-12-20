# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:owasps_refs) do
      primary_key %i[cve_id reference_id]
      foreign_key :cve_id, :owasps
      foreign_key :reference_id, :owasp_refs

      index %i[cve_id reference_id]
    end
  end
end
