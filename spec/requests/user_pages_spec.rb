require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "Signup page" do
    before { visit signup_path }

    it { should have_selector "title", :text => full_title("Sign up") }
    it { should have_selector "h1", :text => "Sign up" }

    describe "Signup" do
      let(:submit) { "Create my account" }

      describe "with invalid information" do
        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end

        describe "after submission" do
          before { click_button submit }

          it { should have_selector "title", text: "Sign up" }
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
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_selector "title", :text => user.name }
    it { should have_selector "h1", :text => user.name}
  end
end