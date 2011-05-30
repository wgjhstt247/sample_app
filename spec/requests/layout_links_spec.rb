require 'spec_helper'

describe "LayoutLinks" do

	it "should have a Home page at '/'" do
		get '/'
		response.should have_selector('title', :content => "Home")
	end
	
	it "should have a Contact page at '/contact'" do
		get '/contact'
		response.should have_selector('title', :content => "Contact")
	end
	
	it "should have an About page at '/about'" do
		get '/about'
		response.should have_selector('title', :content => "About")
	end

	it "should have a Help page at '/help'" do
		get '/help'
		response.should have_selector('title', :content => "Help")
	end

	it "should have a Signup page at '/signup'" do
		get '/signup'
		response.should have_selector('title', :content => "Sign up")
	end

	it "should have the right links on the layout" do
		visit root_path
		click_link "About"
		response.should have_selector('title', :content => "About")
		click_link "Help"
		response.should have_selector('title', :content => "Help")
		click_link "Contact"
		response.should have_selector('title', :content => "Contact")
		click_link "Home"
		response.should have_selector('title', :content => "Home")
		click_link "Sign up now!"
		response.should have_selector('title', :content => "Sign up")
	end

	describe "when not signed in" do
		it "should have a signin link" do
			visit root_path
			response.should have_selector("a", :href => signin_url(:protocol => 'https'),
												:content => "Sign in")
		end
	end

	describe "when signed in" do

		before(:each) do
			@user = Factory(:user, :admin => true)
			integration_sign_in(@user)
		end

		it "should have a signout link" do
			visit root_path
			response.should have_selector("a", :href => signout_url(:protocol => 'http'),
												:content => "Sign out")
		end

		it "should have a profile link" do
			visit root_path
			response.should have_selector("a", :href => user_url(@user, :protocol => 'http'),
											   :content => "Profile")
		end

		describe "as admin" do
		
			it "should show the delete links on the Users index" do
				visit root_path
				click_link "Users"
				response.should have_selector("a", :href => user_url(@user, :protocol => 'http'),
												   :content => "delete")
			end
		end

		describe "as non-admin" do

			it "should not show the delete links on the Users index" do
				@user.toggle!(:admin)
				visit root_path
				click_link "Users"
				response.should_not have_selector("a", :href => user_url(@user, :protocol => 'http'),
													   :content => "delete")
			end
		end
	end
end
