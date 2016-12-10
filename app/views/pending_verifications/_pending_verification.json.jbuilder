json.extract! pending_verification, :id, :root, :domain, :created_at, :updated_at
json.url pending_verification_url(pending_verification, format: :json)