defmodule Spendable.Web.Controllers.WellKnown do
  use Spendable.Web, :controller

  def apple_app_site_association(conn, _params) do
    json(conn, %{
      webcredentials: %{
        apps: ["A4TA99R8XM.fiftysevenmedia.Spendable"]
      },
      appLinks: %{
        apps: [],
        details: [
          appIDs: ["A4TA99R8XM.fiftysevenmedia.Spendable"],
          components: [
            %{
              /: "/plaid/oauth.html"
            },
            %{
              /: "/plaid/oauth"
            }
          ]
        ]
      }
    })
  end
end
