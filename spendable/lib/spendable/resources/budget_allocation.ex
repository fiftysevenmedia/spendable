defmodule Spendable.BudgetAllocation do
  use Ash.Resource,
    authorizers: [Ash.Policy.Authorizer],
    data_layer: AshPostgres.DataLayer

  postgres do
    repo(Spendable.Repo)
    table "budget_allocations"

    custom_indexes do
      index(["budget_id"])
      index(["transaction_id"])
      index(["user_id"])
    end
  end

  attributes do
    integer_primary_key :id

    attribute :amount, :decimal, allow_nil?: false

    timestamps()
  end

  relationships do
    belongs_to :transaction, Spendable.Transaction, allow_nil?: false, attribute_type: :integer
    belongs_to :budget, Spendable.Budget, allow_nil?: false, attribute_type: :integer
    belongs_to :user, Spendable.User, allow_nil?: false, attribute_type: :integer
  end

  actions do
    defaults [:read, :create, :update, :destroy]
  end

  policies do
    policy always() do
      authorize_if action(:create)
      authorize_if expr(user_id == actor(:id))
    end
  end
end
