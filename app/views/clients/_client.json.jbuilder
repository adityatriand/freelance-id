json.extract! client, :id, :name, :phone, :date_birth, :type_industry, :user_id, :created_at, :updated_at
json.url client_url(client, format: :json)
