json.extract! request, :id, :tags, :status, :created_by, :created_at, :updated_at
json.url request_url(request, format: :json)
