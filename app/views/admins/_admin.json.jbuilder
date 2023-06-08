json.extract! admin, :id, :name, :email, :password, :organization_id, :created_at, :updated_at
json.url admin_url(admin, format: :json)
