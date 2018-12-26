# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:cves) do
      primary_key :id
      String      :overview
      String      :vultype
      String      :zeroday_price
      String      :affected_product
      String      :affected_vendor
      Integer     :tweet_count
      String      :CVE_ID, unique: true, null: false
      DateTime    :release_date
      DateTime    :revise_date

      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
