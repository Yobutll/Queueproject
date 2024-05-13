Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*' # ให้อนุญาตทุกโดเมนเข้าถึง
      resource '*', headers: :any, methods: [:get, :post, :put, :patch, :delete, :options]
    end
  end