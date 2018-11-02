# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:tweets_experts) do
      primary_key %i[tweet_id expert_id]
      foreign_key :tweet_id, :tweets
      foreign_key :expert_id, :experts

      index %i[tweet_id expert_id]
    end
  end
end
