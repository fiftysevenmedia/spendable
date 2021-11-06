defmodule Spendable.Repo.Migrations.MigrateResources5 do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    drop constraint(
           :budget_allocation_template_lines,
           "budget_allocation_template_lines_budget_allocation_template_id_"
         )

    alter table(:budget_allocation_template_lines) do
      modify :updated_at, :utc_datetime_usec, default: fragment("now()")
      modify :inserted_at, :utc_datetime_usec, default: fragment("now()")

      modify :budget_allocation_template_id,
             references(:budget_allocation_templates,
               column: :id,
               name: "budget_allocation_template_lines_budget_allocation_template_id_fkey",
               type: :bigint
             )
    end

    create index(:budget_allocation_template_lines, [:user_id], name: "budget_allocation_template_lines_user_id_index")
  end

  def down do
    drop index(:budget_allocation_template_lines, [:user_id], name: "budget_allocation_template_lines_user_id_index")

    drop constraint(
           :budget_allocation_template_lines,
           "budget_allocation_template_lines_budget_allocation_template_id_fkey"
         )

    alter table(:budget_allocation_template_lines) do
      modify :budget_allocation_template_id,
             references(:budget_allocation_templates,
               column: :id,
               name: "budget_allocation_template_lines_budget_allocation_template_id_",
               type: :bigint
             )

      modify :inserted_at, :utc_datetime, default: nil
      modify :updated_at, :utc_datetime, default: nil
    end
  end
end