defmodule Spendable.User.Types do
  use Absinthe.Schema.Notation

  alias Spendable.Middleware.CheckAuthentication
  alias Spendable.User.Resolver
  alias Spendable.User.Utils

  object :user do
    field :id, :id
    field :bank_limit, :integer
    field :email, :string
    field :token, :string

    field :spendable, :string do
      complexity(50)

      resolve(fn user, _args, _resolution ->
        {:ok, Utils.calculate_spendable(user)}
      end)
    end
  end

  object :user_queries do
    field :current_user, :user do
      middleware(CheckAuthentication)
      resolve(&Resolver.current_user/2)
    end
  end

  object :user_mutations do
    field :create_user, :user do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&Resolver.create/2)
    end

    field :update_user, :user do
      middleware(CheckAuthentication)
      arg(:email, non_null(:string))
      arg(:password, :string)
      resolve(&Resolver.update/2)
    end
  end
end
