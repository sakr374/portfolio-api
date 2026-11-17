Rails.application.config.middleware.insert_before 0, Rack::Cors do
  # Comma-separated list of allowed frontend origins, e.g.
  # FRONTEND_ORIGINS=https://your-site.netlify.app,https://your-custom-domain.com
  allowed_origins = ENV.fetch(
    "FRONTEND_ORIGINS",
    "http://localhost:5173,http://localhost:3001,http://localhost:3000"
  ).split(",").map(&:strip).reject(&:blank?)

  # Always allow local development, even when production origins are configured.
  allowed_origins |= [
    "http://localhost:5173",
    "http://localhost:3001",
    "http://localhost:3000"
  ]

  allow do
    origins(*allowed_origins)

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true,
      expose: ['Authorization']
  end
end
