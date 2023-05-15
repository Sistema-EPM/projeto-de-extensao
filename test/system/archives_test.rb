require "application_system_test_case"

class ArchivesTest < ApplicationSystemTestCase
  setup do
    @archive = archives(:one)
  end

  test "visiting the index" do
    visit archives_url
    assert_selector "h1", text: "Archives"
  end

  test "should create archive" do
    visit archives_url
    click_on "New archive"

    fill_in "Original name", with: @archive.original_name
    fill_in "Path", with: @archive.path
    fill_in "Report", with: @archive.report_id
    fill_in "Size", with: @archive.size
    fill_in "Title", with: @archive.title
    fill_in "Type", with: @archive.type
    click_on "Create Archive"

    assert_text "Archive was successfully created"
    click_on "Back"
  end

  test "should update Archive" do
    visit archive_url(@archive)
    click_on "Edit this archive", match: :first

    fill_in "Original name", with: @archive.original_name
    fill_in "Path", with: @archive.path
    fill_in "Report", with: @archive.report_id
    fill_in "Size", with: @archive.size
    fill_in "Title", with: @archive.title
    fill_in "Type", with: @archive.type
    click_on "Update Archive"

    assert_text "Archive was successfully updated"
    click_on "Back"
  end

  test "should destroy Archive" do
    visit archive_url(@archive)
    click_on "Destroy this archive", match: :first

    assert_text "Archive was successfully destroyed"
  end
end
