require "application_system_test_case"

class ResponsiblesTest < ApplicationSystemTestCase
  setup do
    @responsible = responsibles(:one)
  end

  test "visiting the index" do
    visit responsibles_url
    assert_selector "h1", text: "Responsibles"
  end

  test "should create responsible" do
    visit responsibles_url
    click_on "New responsible"

    fill_in "Email", with: @responsible.email
    fill_in "Name", with: @responsible.name
    fill_in "Password", with: @responsible.password
    click_on "Create Responsible"

    assert_text "Responsible was successfully created"
    click_on "Back"
  end

  test "should update Responsible" do
    visit responsible_url(@responsible)
    click_on "Edit this responsible", match: :first

    fill_in "Email", with: @responsible.email
    fill_in "Name", with: @responsible.name
    fill_in "Password", with: @responsible.password
    click_on "Update Responsible"

    assert_text "Responsible was successfully updated"
    click_on "Back"
  end

  test "should destroy Responsible" do
    visit responsible_url(@responsible)
    click_on "Destroy this responsible", match: :first

    assert_text "Responsible was successfully destroyed"
  end
end
