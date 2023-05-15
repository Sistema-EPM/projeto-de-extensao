require "application_system_test_case"

class ProjectsTest < ApplicationSystemTestCase
  setup do
    @project = projects(:one)
  end

  test "visiting the index" do
    visit projects_url
    assert_selector "h1", text: "Projects"
  end

  test "should create project" do
    visit projects_url
    click_on "New project"

    fill_in "Competency", with: @project.competency
    fill_in "Course", with: @project.course_id
    fill_in "Description", with: @project.description
    fill_in "Feedback", with: @project.feedback_id
    fill_in "Modality", with: @project.modality
    fill_in "Name", with: @project.name
    fill_in "Ods project", with: @project.ods_project_id
    fill_in "Organization", with: @project.organization_id
    fill_in "Responsible", with: @project.responsible_id
    fill_in "Status", with: @project.status
    click_on "Create Project"

    assert_text "Project was successfully created"
    click_on "Back"
  end

  test "should update Project" do
    visit project_url(@project)
    click_on "Edit this project", match: :first

    fill_in "Competency", with: @project.competency
    fill_in "Course", with: @project.course_id
    fill_in "Description", with: @project.description
    fill_in "Feedback", with: @project.feedback_id
    fill_in "Modality", with: @project.modality
    fill_in "Name", with: @project.name
    fill_in "Ods project", with: @project.ods_project_id
    fill_in "Organization", with: @project.organization_id
    fill_in "Responsible", with: @project.responsible_id
    fill_in "Status", with: @project.status
    click_on "Update Project"

    assert_text "Project was successfully updated"
    click_on "Back"
  end

  test "should destroy Project" do
    visit project_url(@project)
    click_on "Destroy this project", match: :first

    assert_text "Project was successfully destroyed"
  end
end
