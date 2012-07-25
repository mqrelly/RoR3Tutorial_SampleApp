require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "sign in page" do
    before { visit signin_path }

    it { should have_selector "title", text: "Sign in" }
    it { should have_selector "h1", text: "Sign in" }

    describe "with invalid credentials" do
      before { click_button "Sign in" }

      it { should have_selector "title", text: "Sign in" }
      it { should have_selector "div.alert.alert-error", text: "Invalid" }

      describe "after visiting anouther page" do
        before { click_link "Home" }
        it { should_not have_selector "div.alert.alert-error", text: "Invalid" }
      end
    end

    describe "with valid credentials" do
      let(:user) { FactoryGirl.create :user }
      before do
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { should have_selector "title", text: user.name }
      it { should have_link "Profile", href: user_path(user) }
      it { should have_link "Sign out", href: signout_path }
      it { should_not have_link "Sign in", href: signin_path }
    end
  end
end
