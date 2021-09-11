defmodule Spendable.Web.Schema do
  use Absinthe.Schema

  @apis [Spendable.Api]

  use AshGraphql, apis: @apis

  import_types(Absinthe.Type.Custom)

  import_types(Spendable.Budgets.Allocation.Types)
  import_types(Spendable.Budgets.AllocationTemplate.Types)
  import_types(Spendable.Budgets.AllocationTemplateLine.Types)
  import_types(Spendable.Budgets.Budget.Types)

  query do
    field :health, :string, resolve: fn _args, _resolution -> {:ok, "up"} end
    import_fields(:allocation_queries)
    import_fields(:allocation_template_line_queries)
    import_fields(:allocation_template_queries)
    import_fields(:budget_queries)
  end

  mutation do
    import_fields(:allocation_mutations)
    import_fields(:allocation_template_line_mutations)
    import_fields(:allocation_template_mutations)
    import_fields(:budget_mutations)
  end

  def context(context) do
    context = AshGraphql.add_context(context, @apis)

    loader =
      context
      |> Map.fetch!(:loader)
      |> Dataloader.add_source(Spendable, Spendable.data())

    Map.put(context, :loader, loader)
  end

  def plugins() do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  def middleware(middleware, _field, %{identifier: :mutation}) do
    # this middleware needs to append to the end
    # credo:disable-for-next-line Credo.Check.Refactor.AppendSingleItem
    middleware ++ [Spendable.Middleware.ChangesetErrors]
  end

  # if it's any other object keep things as is
  def middleware(middleware, _field, _object), do: middleware

  def pipeline(config, pipeline_opts) do
    config.schema_mod
    |> Absinthe.Pipeline.for_document(pipeline_opts)
    |> Absinthe.Pipeline.insert_after(Absinthe.Phase.Document.Complexity.Analysis, Spendable.Web.Utils.LogComplexity)
  end
end
