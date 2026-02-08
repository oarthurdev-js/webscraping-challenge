# frozen_string_literal: true

require "rails_helper"

RSpec.describe WebmotorsScraper do
  describe ".call" do
    context "when URL is valid" do
      it "returns a hash with scraped data" do
        allow(HTTParty).to receive(:get).and_return(
          double(
            code: 200,
            body: <<~HTML
              <html>
                <head><title>Test Vehicle</title></head>
                <body>
                  <script id="__NEXT_DATA__">
                    {"props":{"pageProps":{"ad":{"Make":"Honda","Model":"Civic","Version":"EX","Prices":{"Price":"80000"}}}}}
                  </script>
                </body>
              </html>
            HTML
          )
        )

        result = WebmotorsScraper.call("https://www.webmotors.com.br/comprar/test")

        expect(result).to be_a(Hash)
        expect(result[:brand]).to eq("Honda")
        expect(result[:model]).to eq("Civic")
        expect(result[:price]).to eq("80000")
      end
    end

    context "when access is denied" do
      it "returns error data" do
        allow(HTTParty).to receive(:get).and_return(
          double(
            code: 403,
            body: "<html><head><title>Access to this page has been denied</title></head></html>"
          )
        )

        result = WebmotorsScraper.call("https://www.webmotors.com.br/comprar/test")

        expect(result[:brand]).to eq("Erro")
        expect(result[:description]).to include("bloqueado")
      end
    end

    context "when vehicle is sold" do
      it "returns sold status" do
        allow(HTTParty).to receive(:get).and_return(
          double(
            code: 200,
            body: "<html><head><title>Veículo Vendido</title></head><body>Veeeennndeeeeuuu</body></html>"
          )
        )

        result = WebmotorsScraper.call("https://www.webmotors.com.br/comprar/test")

        expect(result[:description]).to include("vendido")
      end
    end
  end
end
