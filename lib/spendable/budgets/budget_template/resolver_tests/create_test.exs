defmodule Spendable.Budgets.BudgetTemplate.Resolver.CreateTest do
  use Spendable.Web.ConnCase, async: true
  import Spendable.Factory

  test "create budget template", %{conn: conn} do
    {user, token} = Spendable.TestUtils.create_user()

    budget = insert(:budget, user_id: user.id)

    query = """
      mutation {
        createBudgetTemplate(
          name: "test budget template"
          lines: [
            {
              amount: "5"
              budget_id: "#{budget.id}"
              priority: 0
            }
          ]
        ) {
          name
          lines {
            amount
            priority
            budget {
              id
              name
            }
          }
        }
      }
    """

    response =
      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> post("/graphql", %{query: query})
      |> json_response(200)

    assert %{
             "data" => %{
               "createBudgetTemplate" => %{
                 "name" => "test budget template",
                 "lines" => [
                   %{
                     "amount" => "5.00",
                     "budget" => %{"id" => "#{budget.id}", "name" => "Food"},
                     "priority" => 0
                   }
                 ]
               }
             }
           } == response
  end
end
