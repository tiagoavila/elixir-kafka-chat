defmodule ElixirKafkaChat.Repo.Migrations.AddUsernamesAndNamesToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :username, :citext, null: false
      add :first_name, :string, null: false
    end
    create unique_index(:users, :username)
  end
end
