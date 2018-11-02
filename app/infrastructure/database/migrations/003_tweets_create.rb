# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:tweets) do
      primary_key :id
      foreign_key :cve_id, :cves
      foreign_key :owner_id, :experts
      String      :content
      Integer     :reply_count
      Integer     :favorite_count
      Integer     :retweet_count
      DateTime    :time

      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
