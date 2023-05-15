require "test_helper"

class OdsProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ods_project = ods_projects(:one)
  end

  test "should get index" do
    get ods_projects_url
    assert_response :success
  end

  test "should get new" do
    get new_ods_project_url
    assert_response :success
  end

  test "should create ods_project" do
    assert_difference("OdsProject.count") do
      post ods_projects_url, params: { ods_project: { name: @ods_project.name } }
    end

    assert_redirected_to ods_project_url(OdsProject.last)
  end

  test "should show ods_project" do
    get ods_project_url(@ods_project)
    assert_response :success
  end

  test "should get edit" do
    get edit_ods_project_url(@ods_project)
    assert_response :success
  end

  test "should update ods_project" do
    patch ods_project_url(@ods_project), params: { ods_project: { name: @ods_project.name } }
    assert_redirected_to ods_project_url(@ods_project)
  end

  test "should destroy ods_project" do
    assert_difference("OdsProject.count", -1) do
      delete ods_project_url(@ods_project)
    end

    assert_redirected_to ods_projects_url
  end
end
