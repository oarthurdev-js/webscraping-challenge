require "httparty"
require "nokogiri"

class WebmotorsScraper
  def self.call(url)
    Rails.logger.info "Scraping URL with HTTParty + Nokogiri: #{url}"
    
    headers = {
      "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
      "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8",
      "Accept-Language" => "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7",
      "Accept-Encoding" => "gzip, deflate, br",
      "Cache-Control" => "no-cache",
      "Sec-Ch-Ua" => '"Not_A Brand";v="8", "Chromium";v="120", "Google Chrome";v="120"',
      "Sec-Ch-Ua-Mobile" => "?0",
      "Sec-Ch-Ua-Platform" => '"macOS"',
      "Sec-Fetch-Dest" => "document",
      "Sec-Fetch-Mode" => "navigate",
      "Sec-Fetch-Site" => "none",
      "Sec-Fetch-User" => "?1",
      "Upgrade-Insecure-Requests" => "1"
    }

    options = { headers: headers, timeout: 30 }

    # Add proxy support if configured
    if ENV["PROXY_URL"].present?
      proxy_uri = URI.parse(ENV["PROXY_URL"])
      options[:http_proxyaddr] = proxy_uri.host
      options[:http_proxyport] = proxy_uri.port
      options[:http_proxyuser] = proxy_uri.user if proxy_uri.user
      options[:http_proxypass] = proxy_uri.password if proxy_uri.password
      Rails.logger.info "Using Proxy: #{proxy_uri.host}:#{proxy_uri.port}"
    end

    begin
      response = HTTParty.get(url, **options)
      
      Rails.logger.info "Response Status: #{response.code}"
      
      # Parse HTML with Nokogiri
      doc = Nokogiri::HTML(response.body)
      
      # Check for access denied
      title = doc.at_css("title")&.text || ""
      if title.include?("Access") && title.include?("denied")
        Rails.logger.warn "Access Denied detected"
        return {
          brand: "Erro",
          model: "Erro",
          description: "IP bloqueado - Configure um proxy residencial",
          price: "0",
          scraped_at: Time.current
        }
      end

      # Try to extract JSON data from __NEXT_DATA__
      script = doc.at_css("script#__NEXT_DATA__")
      
      if script
        json_data = JSON.parse(script.text)
        ad = json_data.dig("props", "pageProps", "ad")
        
        if ad
          Rails.logger.info "Successfully extracted ad data"
          return {
            brand: ad["Make"] || ad["brand"] || "Unknown",
            model: ad["Model"] || ad["model"] || "Unknown",
            description: ad["Version"] || ad["version"] || title,
            price: ad.dig("Prices", "Price") || ad.dig("prices", "price") || "0",
            scraped_at: Time.current
          }
        end
      end

      # Check if vehicle is sold
      body_text = doc.text
      if body_text.include?("Vendido") || body_text.include?("vendido") || body_text.include?("Veeeennndeeeeuuu")
        return {
          brand: "N/A",
          model: "N/A",
          description: "Este veiculo foi vendido",
          price: "0",
          scraped_at: Time.current
        }
      end

      # Fallback: Extract from meta tags using Nokogiri
      {
        brand: doc.at_css('meta[property="og:brand"]')&.[]("content") || 
               doc.at_css('meta[name="brand"]')&.[]("content") || "Unknown",
        model: doc.at_css('meta[name="keywords"]')&.[]("content")&.split(",")&.first&.strip || "Unknown",
        description: doc.at_css("h1")&.text&.strip || title,
        price: doc.at_css('meta[property="product:price:amount"]')&.[]("content") || "0",
        scraped_at: Time.current
      }

    rescue HTTParty::Error, SocketError, Timeout::Error => e
      Rails.logger.error "HTTParty Scraping failed: #{e.message}"
      {
        brand: "Erro",
        model: "Erro",
        description: "Falha na conexao: #{e.message}",
        price: "0",
        scraped_at: Time.current
      }
    rescue JSON::ParserError => e
      Rails.logger.error "JSON parsing failed: #{e.message}"
      {
        brand: "Erro",
        model: "Erro",
        description: "Falha ao parsear dados",
        price: "0",
        scraped_at: Time.current
      }
    end
  end
end