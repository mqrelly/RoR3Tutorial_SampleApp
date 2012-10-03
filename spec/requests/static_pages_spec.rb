require 'spec_helper'

describe "Static Pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_page_title full_title(page_title) }
    it { should have_title heading }
  end

  it "should have the right link on the layout" do
    visit root_path
    click_link "About"
    should have_page_title full_title("About Us")
    click_link "Help"
    should have_page_title full_title("Help")
    click_link "Contact"
    should have_page_title full_title("Contact")
    click_link "sample app"
    should have_page_title full_title("")
    click_link "Sign up now!"
    should have_page_title full_title("Sign up")
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading) { "Sample App" }
    let(:page_title) { "" }

    it_should_behave_like "all static pages"
    it { should_not have_page_title " | Home" }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        valid_signin user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "following/follower count" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow! user
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end

      describe "should show the proper count of two microposts" do
        it { should have_content "2 microposts" }
      end

      describe "should show the proper count of the only one micropost" do
        before { click_link "delete" }
        it { should have_content "1 micropost" }
      end

      describe "should show the proper count of zero microposts" do
        before do 
          click_link "delete"
          click_link "delete"
        end
        it { should have_content "0 microposts" }
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading) { "Help" }
    let(:page_title) { "Help" }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading) { "About Us" }
    let(:page_title) { "About Us" }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading) { "Contact" }
    let(:page_title) { "Contact" }

    it_should_behave_like "all static pages"
  end
end
