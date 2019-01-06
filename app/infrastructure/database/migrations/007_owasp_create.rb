# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:owasps) do
      primary_key :id
      String      :overview
      Integer     :tweet_count
      String      :CVE_ID
      String      :category
      DateTime    :release_date
      DateTime    :revise_date

      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
