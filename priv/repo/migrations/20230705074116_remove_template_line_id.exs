defmodule Spendable.Repo.Migrations.RemoveTemplateLineId do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    drop constraint("budget_allocation_template_lines", "budget_allocation_template_lines_pkey")

    alter table(:budget_allocation_template_lines) do
      modify :uuid, :uuid, null: false, primary_key: true

      # Attribute removal has been commented out to avoid data loss. See the migration generator documentation for more
      # If you uncomment this, be sure to also uncomment the corresponding attribute *addition* in the `down` migration
      remove :id
    end

    drop_if_exists unique_index(:budget_allocation_template_lines, [:uuid],
                     name: "budget_allocation_template_lines_uuid_index"
                   )
  end

  def down do
    drop constraint("budget_allocation_template_lines", "budget_allocation_template_lines_pkey")

    create unique_index(:budget_allocation_template_lines, [:uuid],
             name: "budget_allocation_template_lines_uuid_index"
           )

    alter table(:budget_allocation_template_lines) do
      # This is the `down` migration of the statement:
      #
      remove :id
      #

      # add :id, :bigserial, null: false, primary_key: true
      modify :uuid, :uuid, null: true, primary_key: false
    end
  end
end