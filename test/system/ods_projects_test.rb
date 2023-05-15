require "application_system_test_case"

class OdsProjectsTest < ApplicationSystemTestCase
  setup do
    @ods_project = ods_projects(:one)
  end

  test "visiting the index" do
    visit ods_projects_url
    assert_selector "h1", text: "Ods projects"
  end

  test "should create ods project" do
    visit ods_projects_url
    click_on "New ods project"

    fill_in "Name", with: @ods_project.name
    click_on "Create Ods project"

    assert_text "Ods project was successfully created"
    click_on "Back"
  end

  test "should update Ods project" do
    visit ods_project_url(@ods_project)
    click_on "Edit this ods project", match: :first

    fill_in "Name", with: @ods_project.name
    click_on "Update Ods project"

    assert_text "Ods project was successfully updated"
    click_on "Back"
  end

  test "should destroy Ods project" do
    visit ods_project_url(@ods_project)
    click_on "Destroy this ods project", match: :first

    assert_text "Ods project was successfully destroyed"
  end
end
