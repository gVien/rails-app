require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear  # clears all deliveries in case if some other test deliver email (note deliveries is an array)
    @user = users(:gai)
  end

  # the steps to reset password test
  # 1. visit the forgot password link
  # 2. verify the forgot password template renders properly

  # wrong email
  # 3. enter an email that is not valid (not in database) - post request
  # 4. verify email is not valid (flash is not empty)
  # 5. verify the forgot password template renders properly (again)

  # correct email
  # 5.1 enter an email that is valid - post request
  # 5.2. verify the reset digest before case #5 is not equal to after case #5
  # 5.3. verify the email delivery size is 1 more than before
  # 6. verify email is not valid (flash is not empty)
  # 7. verify the root url template renders properly (since if it's a valid email then it redirects to the root url)

  # checks email and click on link
  # 8. assign the user from the ctrler (reset ctrler?)

  # if user modify the form and put in wrong email, we need to make sure it's invalid
  # 9. get the form of password reset with wrong email in url link
  # 10. verify that it redirects to root url
  # 11. verify flash is not empty (optional since I added more features)

  # inactive user (activated attribute is false)
  # 12. toggle activated user & get the edit form with invalid email in link
  # 13. verify the site redirects to root url
  # 14. toggle activated user

  # correct email but wrong token
  # 15. get the edit form with the right email but wrong token in url link below
  # e.g. http://localhost:3000/password_resets/OjvqMyB1Q5A_F2gASDn9WQ/edit?email=thehell%40gmail.com
  # 16. verify the site redirects to root url

  # correct email, right token
  # 17. get the edit form with right email + right token in link
  # 18. verify the template for edit form renders properly
  # 19. verify the hidden email field input is present in the form

  # edit form test
  # invalid password and confirmation
  # 20. patch password reset with invalid password + password confirmation (e.g. too short or do not match) for user
  # 21. verify the div with "error explanation" class appears

  # empty password
  # 22. patch password reset with empty password + password confirmation for user
  # 23. verify the div with "error explanation" class appears

  # valid password + confirmation
  # 24. patch password reset with valid password + password confirmation for user
  # 25. verify the user is logged in
  # 26. verify the flash is not empty (since there is success message)
  # 27. verify the user is being redirected to the user profile page
  test "reset password" do
    get(new_password_reset_path)  # 1
    assert_template('password_resets/new')  # 2

    # wrong invalid email
    post password_resets_path, password_reset: { email: "" } # 3
    assert_not(flash.empty?)   # 4
    assert_template('password_resets/new')  # 5

    # Valid email
    post password_resets_path, password_reset: { email: @user.email } #5.1
    assert_not_equal @user.reset_digest, @user.reload.reset_digest  #5.2
    assert_equal 1, ActionMailer::Base.deliveries.size  #5.3
    assert_not flash.empty? #6
    assert_redirected_to(root_url) #7

    # Password reset form
    user = assigns(:user) #8

    # Wrong email
    get edit_password_reset_path(user.reset_token, email: "") #9
    assert_redirected_to(root_url)  #10
    assert_not flash.empty? #11

    # Inactive user
    user.toggle!(:activated)  #12
    get edit_password_reset_path(user.reset_token, email: user.email) #12
    assert_redirected_to(root_url)  #13
    user.toggle!(:activated) #14

    # Right email, wrong token
    get edit_password_reset_path('wrong token', email: user.email) #15
    assert_redirected_to(root_url)  #16

    # Right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)   #17
    assert_template 'password_resets/edit'  #18
    assert_select "input[name=email][type=hidden][value=?]", user.email #19
    # Invalid password & confirmation

    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:              "123456",
                  password_confirmation: "678901" } #20
    assert_select 'div#error_explanation' #21

    # Empty password
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:              "",
                  password_confirmation: "" } #22
    assert_select 'div#error_explanation' #23

    # Valid password & confirmation
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:              "123456",
                  password_confirmation: "123456" } #24
    assert is_logged_in?  #25
    assert_not flash.empty? #26
    assert_redirected_to user   #27
  end
end
