json.extract! archive, :id, :title, :path, :original_name, :type, :size, :report_id, :created_at, :updated_at
json.url archive_url(archive, format: :json)
