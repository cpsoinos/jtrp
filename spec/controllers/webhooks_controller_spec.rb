describe WebhooksController do

  let(:processor) { double('processor') }

  before do
    allow(WebhookProcessor).to receive(:new).and_return(processor)
    allow(processor).to receive(:process)
  end

  context "clover" do

    let(:data) do
      {
        "appId" => "app_id",
        "merchants" => {
          "merchant_id" => [
            {
              "ts" => 1471468454254,
              "type" => "UPDATE",
              "objectId" =>
              "O:order_id"
            }
          ]
        },
        integration_name: "clover"
      }
    end

    describe "POST receive" do

      it "returns 'ok' when authorized" do
        set_clover_headers
        post :receive, data

        expect(response).to have_http_status(:ok)
      end

      it "returns 'bad request' when unauthorized" do
        post :receive, data

        expect(response).to have_http_status(:bad_request)
      end

    end

  end

end
