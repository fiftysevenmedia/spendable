defmodule Spendable.Repo.Migrations.AllocationUuid do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create index(:budget_allocations, ["user_id"])

    create index(:budget_allocations, ["transaction_id"])

    create index(:budget_allocations, ["budget_id"])

    alter table(:budget_allocations) do
      remove :id
      modify :uuid, :uuid, null: false, primary_key: true
    end

    rename table(:budget_allocations), :uuid, to: :id

    drop_if_exists unique_index(:budget_allocations, [:uuid],
                     name: "budget_allocations_uuid_index"
                   )
  end

  def down do
    create unique_index(:budget_allocations, [:uuid], name: "budget_allocations_uuid_index")

    alter table(:budget_allocations) do
      modify :id, :bigint, default: nil
      # This is the `down` migration of the statement:
      #
      #     remove :uuid
      #

      # add :uuid, :uuid, default: fragment("uuid_generate_v4()")
    end

    drop_if_exists index(:budget_allocations, ["budget_id"],
                     name: "budget_allocations_budget_id_index"
                   )

    drop_if_exists index(:budget_allocations, ["transaction_id"],
                     name: "budget_allocations_transaction_id_index"
                   )

    drop_if_exists index(:budget_allocations, ["user_id"],
                     name: "budget_allocations_user_id_index"
                   )
  end
end
