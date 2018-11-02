# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:cves_tweets) do
      primary_key %i[cve_id tweet_id]
      foreign_key :cve_id, :cves
      foreign_key :tweet_id, :tweets

      index %i[cve_id tweet_id]
    end
  end
end
