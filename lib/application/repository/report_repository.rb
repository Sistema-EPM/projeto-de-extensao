module Application
  module Repository
    class ReportRepository
      def initialize
        @model = Report
      end

      def reported_effort_for_student(student_id:)
        @model.where(student_id: student_id).sum(:report_effort)
      end

      def reported_effort_for_project(project_id:)
        @model.where(project_id: project_id).sum(:report_effort)
      end
    end
  end
