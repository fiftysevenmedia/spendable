defmodule Spendable.Repo.Migrations.MigrateResources16 do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    drop constraint(:transactions, "transactions_user_id_fkey")

    drop constraint(:transactions, "transactions_bank_transaction_id_fkey")

    alter table(:transactions) do
      modify :bank_transaction_id,
             references(:bank_transactions,
               column: :id,
               prefix: "public",
               name: "transactions_bank_transaction_id_fkey",
               type: :bigint
             )
    end

    alter table(:transactions) do
      modify :user_id,
             references(:users,
               column: :id,
               prefix: "public",
               name: "transactions_user_id_fkey",
               type: :bigint
             )
    end

    drop constraint(:notification_settings, "notification_settings_user_id_fkey")

    alter table(:notification_settings) do
      modify :device_token, :text, default: false

      modify :user_id,
             references(:users,
               column: :id,
               prefix: "public",
               name: "notification_settings_user_id_fkey",
               type: :bigint
             )
    end

    drop constraint(:budgets, "budgets_user_id_fkey")

    alter table(:budgets) do
      modify :adjustment, :decimal, default: "0.00"

      modify :user_id,
             references(:users,
               column: :id,
               prefix: "public",
               name: "budgets_user_id_fkey",
               type: :bigint
             )
    end

    drop constraint(:budget_allocations, "budget_allocations_user_id_fkey")

    drop constraint(:budget_allocations, "budget_allocations_budget_id_fkey")

    drop constraint(:budget_allocations, "budget_allocations_transaction_id_fkey")

    alter table(:budget_allocations) do
      modify :transaction_id,
             references(:transactions,
               column: :id,
               prefix: "public",
               name: "budget_allocations_transaction_id_fkey",
               type: :bigint
             )
    end

    alter table(:budget_allocations) do
      modify :budget_id,
             references(:budgets,
               column: :id,
               prefix: "public",
               name: "budget_allocations_budget_id_fkey",
               type: :bigint
             )
    end

    alter table(:budget_allocations) do
      modify :user_id,
             references(:users,
               column: :id,
               prefix: "public",
               name: "budget_allocations_user_id_fkey",
               type: :bigint
             )
    end

    drop constraint(:budget_allocation_templates, "budget_allocation_templates_user_id_fkey")

    alter table(:budget_allocation_templates) do
      modify :user_id,
             references(:users,
               column: :id,
               prefix: "public",
               name: "budget_allocation_templates_user_id_fkey",
               type: :bigint
             )
    end

    drop constraint(
           :budget_allocation_template_lines,
           "budget_allocation_template_lines_user_id_fkey"
         )

    drop constraint(
           :budget_allocation_template_lines,
           "budget_allocation_template_lines_budget_allocation_template_id_fkey"
         )

    drop constraint(
           :budget_allocation_template_lines,
           "budget_allocation_template_lines_budget_id_fkey"
         )

    alter table(:budget_allocation_template_lines) do
      modify :budget_id,
             references(:budgets,
               column: :id,
               prefix: "public",
               name: "budget_allocation_template_lines_budget_id_fkey",
               type: :bigint
             )
    end

    alter table(:budget_allocation_template_lines) do
      modify :budget_allocation_template_id,
             references(:budget_allocation_templates,
               column: :id,
               prefix: "public",
               name: "budget_allocation_template_lines_budget_allocation_template_id_fkey",
               type: :bigint,
               on_delete: :delete_all
             )
    end

    alter table(:budget_allocation_template_lines) do
      modify :user_id,
             references(:users,
               column: :id,
               prefix: "public",
               name: "budget_allocation_template_lines_user_id_fkey",
               type: :bigint
             )
    end

    drop constraint(:bank_transactions, "bank_transactions_bank_account_id_fkey")

    drop constraint(:bank_transactions, "bank_transactions_user_id_fkey")

    alter table(:bank_transactions) do
      modify :user_id,
             references(:users,
               column: :id,
               prefix: "public",
               name: "bank_transactions_user_id_fkey",
               type: :bigint
             )
    end

    alter table(:bank_transactions) do
      modify :bank_account_id,
             references(:bank_accounts,
               column: :id,
               prefix: "public",
               name: "bank_transactions_bank_account_id_fkey",
               type: :bigint
             )
    end

    drop constraint(:bank_members, "bank_members_user_id_fkey")

    alter table(:bank_members) do
      modify :user_id,
             references(:users,
               column: :id,
               prefix: "public",
               name: "bank_members_user_id_fkey",
               type: :bigint
             )
    end

    drop constraint(:bank_accounts, "bank_accounts_bank_member_id_fkey")

    drop constraint(:bank_accounts, "bank_accounts_user_id_fkey")

    alter table(:bank_accounts) do
      modify :user_id,
             references(:users,
               column: :id,
               prefix: "public",
               name: "bank_accounts_user_id_fkey",
               type: :bigint
             )
    end

    alter table(:bank_accounts) do
      modify :bank_member_id,
             references(:bank_members,
               column: :id,
               prefix: "public",
               name: "bank_accounts_bank_member_id_fkey",
               type: :bigint
             )
    end
  end

  def down do
    drop constraint(:bank_accounts, "bank_accounts_bank_member_id_fkey")

    alter table(:bank_accounts) do
      modify :bank_member_id,
             references(:bank_members,
               column: :id,
               name: "bank_accounts_bank_member_id_fkey",
               type: :bigint
             )
    end

    drop constraint(:bank_accounts, "bank_accounts_user_id_fkey")

    alter table(:bank_accounts) do
      modify :user_id,
             references(:users, column: :id, name: "bank_accounts_user_id_fkey", type: :bigint)
    end

    drop constraint(:bank_members, "bank_members_user_id_fkey")

    alter table(:bank_members) do
      modify :user_id,
             references(:users, column: :id, name: "bank_members_user_id_fkey", type: :bigint)
    end

    drop constraint(:bank_transactions, "bank_transactions_bank_account_id_fkey")

    alter table(:bank_transactions) do
      modify :bank_account_id,
             references(:bank_accounts,
               column: :id,
               name: "bank_transactions_bank_account_id_fkey",
               type: :bigint
             )
    end

    drop constraint(:bank_transactions, "bank_transactions_user_id_fkey")

    alter table(:bank_transactions) do
      modify :user_id,
             references(:users, column: :id, name: "bank_transactions_user_id_fkey", type: :bigint)
    end

    drop constraint(
           :budget_allocation_template_lines,
           "budget_allocation_template_lines_user_id_fkey"
         )

    alter table(:budget_allocation_template_lines) do
      modify :user_id,
             references(:users,
               column: :id,
               name: "budget_allocation_template_lines_user_id_fkey",
               type: :bigint
             )
    end

    drop constraint(
           :budget_allocation_template_lines,
           "budget_allocation_template_lines_budget_allocation_template_id_fkey"
         )

    alter table(:budget_allocation_template_lines) do
      modify :budget_allocation_template_id,
             references(:budget_allocation_templates,
               column: :id,
               name: "budget_allocation_template_lines_budget_allocation_template_id_fkey",
               type: :bigint,
               on_delete: :delete_all
             )
    end

    drop constraint(
           :budget_allocation_template_lines,
           "budget_allocation_template_lines_budget_id_fkey"
         )

    alter table(:budget_allocation_template_lines) do
      modify :budget_id,
             references(:budgets,
               column: :id,
               name: "budget_allocation_template_lines_budget_id_fkey",
               type: :bigint
             )
    end

    drop constraint(:budget_allocation_templates, "budget_allocation_templates_user_id_fkey")

    alter table(:budget_allocation_templates) do
      modify :user_id,
             references(:users,
               column: :id,
               name: "budget_allocation_templates_user_id_fkey",
               type: :bigint
             )
    end

    drop constraint(:budget_allocations, "budget_allocations_user_id_fkey")

    alter table(:budget_allocations) do
      modify :user_id,
             references(:users,
               column: :id,
               name: "budget_allocations_user_id_fkey",
               type: :bigint
             )
    end

    drop constraint(:budget_allocations, "budget_allocations_budget_id_fkey")

    alter table(:budget_allocations) do
      modify :budget_id,
             references(:budgets,
               column: :id,
               name: "budget_allocations_budget_id_fkey",
               type: :bigint
             )
    end

    drop constraint(:budget_allocations, "budget_allocations_transaction_id_fkey")

    alter table(:budget_allocations) do
      modify :transaction_id,
             references(:transactions,
               column: :id,
               name: "budget_allocations_transaction_id_fkey",
               type: :bigint
             )
    end

    drop constraint(:budgets, "budgets_user_id_fkey")

    alter table(:budgets) do
      modify :user_id,
             references(:users, column: :id, name: "budgets_user_id_fkey", type: :bigint)

      modify :adjustment, :decimal, default: 0.00
    end

    drop constraint(:notification_settings, "notification_settings_user_id_fkey")

    alter table(:notification_settings) do
      modify :user_id,
             references(:users,
               column: :id,
               name: "notification_settings_user_id_fkey",
               type: :bigint
             )

      modify :device_token, :text, default: nil
    end

    drop constraint(:transactions, "transactions_user_id_fkey")

    alter table(:transactions) do
      modify :user_id,
             references(:users, column: :id, name: "transactions_user_id_fkey", type: :bigint)
    end

    drop constraint(:transactions, "transactions_bank_transaction_id_fkey")

    alter table(:transactions) do
      modify :bank_transaction_id,
             references(:bank_transactions,
               column: :id,
               name: "transactions_bank_transaction_id_fkey",
               type: :bigint
             )
    end
  end
end