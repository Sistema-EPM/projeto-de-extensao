json.extract! report, :id, :reported_effort, :reported_date, :status, :project_id, :student_id, :created_at, :updated_at
json.url report_url(report, format: :json)
