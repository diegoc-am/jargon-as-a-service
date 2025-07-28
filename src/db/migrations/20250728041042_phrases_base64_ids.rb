# frozen_string_literal: true

Sequel.migration do
  transaction
  change do
    drop_table(:phrases)
    create_table(:phrases) do
      String :id, primary_key: true, not_null: true
      String :category, null: false
      String :phrase, null: false
      index [:category]
    end
  end
end
