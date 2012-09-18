require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "Signup page" do
    before { visit signup_path }

    it { should have_page_title full_title("Sign up") }
    it { should have_title "Sign up" }

    describe "Signup" do
      let(:submit) { "Create my account" }

      describe "with invalid information" do
        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end

        describe "after submission" do
          before { click_button submit }

          it { should have_page_title "Sign up" }
          it { should have_selector "div", text: /The form contains \d* error(s?)/ }
          it { should have_selector "li", text: "Name can't be blank" }
          it { should have_selector "li", text: "Email can't be blank" }
          it { should have_selector "li", text: "Email is invalid" }
          it { should have_selector "li", text: "Password can't be blank" }
          it { should have_selector "li", text: "Password is too short" }
          it { should have_selector "li", text: "Password confirmation can't be blank" }
        end
      end

      describe "with valid information" do
        before do
          fill_in "Name", :with => "Example User"
          fill_in "Email", :with => "user@example.com"
          fill_in "Password", :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
        end

        it "should create a new user" do
          expect { click_button submit }.to change(User, :count).by(1)
        end

        describe "after saving the user" do
          before { click_button submit }
          let(:user) { User.find_by_email "user@example.com" }

          it { should have_page_title user.name }
          it { should have_selector "div", text: "Welcom to the Sample App" }
          it { should have_link "Sign out" }
        end
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_page_title user.name }
    it { should have_title user.name}
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      valid_signin(user)
      visit edit_user_path(user)
    end
    
    describe "page" do
      it { should have_page_title "Edit user" }
      it { should have_title "Update your profile" }
      it { should have_link "change", href: "http://gravatar.com/emails" }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content "error" }
    end

    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name", with: new_name
        fill_in "Email",with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirmation", with: user.password
        click_button "Save changes"
      end

      it { should have_page_title new_name }
      it { should have_selector "div.alert.alert-success" }
      it { should have_link "Sign out" }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
    end
  end

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before(:all) { 30.times { FactoryGirl.create(:user) } }
    after(:all) { User.delete_all }

    before(:each) do
      valid_signin user
      visit users_path
    end

    it { should have_page_title "All users" }
    it { should have_title "All users" }

    describe "pagination" do
      it { should have_selector "div.pagination" }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector "li", text: user.name
        end
      end
    end

    describe "delete links" do
      it { should_not have_link "delete" }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          valid_signin admin
          visit users_path
        end

        it { should have_link("delete", href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link "delete" }.to change(User, :count).by(-1)
        end
        it { should_not have_link("delete", href: user_path(admin)) }

        it "should not be able to delete oneself" do
          expect { delete user_path(admin) }.not_to change(User, :count).by(-1)
        end
      end
    end
  end
end
