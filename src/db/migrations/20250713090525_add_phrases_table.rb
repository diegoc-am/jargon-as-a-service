Sequel.migration do
  transaction
  change do
    create_table(:phrases) do
      primary_key :id
      String :category, null: false
      String :phrase, null: false
      index [:category]
    end
  end
end
