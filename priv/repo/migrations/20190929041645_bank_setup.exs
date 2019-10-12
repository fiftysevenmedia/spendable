defmodule Budget.Repo.Migrations.BankSetup do
  use Ecto.Migration

  def change do
    create table(:bank_members) do
      add(:external_id, :string, null: false)
      add(:user_id, references(:users), null: false)
      add(:institution_id, :string)
      add(:logo, :text)
      add(:name, :string, null: false)
      add(:provider, :string, null: false)
      add(:status, :string)
      add(:plaid_token, :string)

      timestamps()
    end

    create unique_index(:bank_members, [:user_id, :external_id])

    create table(:bank_accounts) do
      add(:external_id, :string, null: false)
      add(:user_id, references(:users), null: false)
      add(:bank_member_id, references(:bank_members), null: false)
      add(:available_balance, :decimal, precision: 17, scale: 2)
      add(:balance, :decimal, precision: 17, scale: 2)
      add(:name, :string, null: false)
      add(:number, :string)
      add(:sub_type, :string, null: false)
      add(:type, :string, null: false)
      add(:sync, :boolean, null: false, default: false)

      timestamps()
    end

    create unique_index(:bank_accounts, [:user_id, :external_id])

    create table(:categories) do
      add(:external_id, :string)
      add(:name, :string)
      add(:parent_id, references(:categories))

      timestamps()
    end

    create unique_index(:categories, [:external_id])

    create table(:bank_transactions) do
      add(:external_id, :string, null: false)
      add(:user_id, references(:users), null: false)
      add(:bank_account_id, references(:bank_accounts), null: false)
      add(:category_id, references(:categories))
      add(:amount, :decimal, precision: 17, scale: 2, null: false)
      add(:date, :date, null: false)
      add(:location, :json)
      add(:name, :string, null: false)
      add(:pending, :boolean, null: false)

      timestamps()
    end

    create unique_index(:bank_transactions, [:bank_account_id, :external_id])

    create table(:transactions) do
      add(:user_id, references(:users), null: false)
      add(:bank_transaction_id, references(:bank_transactions))
      add(:category_id, references(:categories))
      add(:amount, :decimal, precision: 17, scale: 2, null: false)
      add(:date, :date, null: false)
      add(:name, :string)
      add(:note, :text)

      timestamps()
    end
  end
end