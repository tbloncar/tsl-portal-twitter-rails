require 'open-uri'
require 'json'

class StudentsController < ApplicationController
	def list
		Twitter.configure do |config|
		  config.consumer_key = "Eseu2C82I6u8D5F2OKOOMw"
		  config.consumer_secret = "zGwHi7aUjSFtb9og1BxIGyikBwVePRXtzor5CnAs0o"
		  config.oauth_token = "370541379-T1RKxsXcbuK6rWGNoawX5evIov0IHpcVkbXanOH3"
		  config.oauth_token_secret = "G943yJqvq5cIBJY2PauToIhQ1Qjg6XZH2Jj5bQXMQ"
		end

		urls = []

		2.times do |i|
			course_num = (i + 36).to_s
			url = "http://yearbook-api.herokuapp.com/2013/Spring/#{course_num}.json"
			urls << url
		end

		list_from_portal_api = {}

		urls.each do |url| 
			raw_response_string = open(url).read
			ruby_response_object = JSON.parse(raw_response_string)
			course_name = ruby_response_object["name"]
			list_from_portal_api[course_name] = ruby_response_object["students"]
		end
		 
		@students = {}

		list_from_portal_api.each do |course, student_array|
			@students[course] = []
		end
		 
		list_from_portal_api.each do |course, student_array|
			student_array.each do |student|
			  s = Student.new
			  s.name = "#{student["first_name"]} #{student["last_name"]}"
			  if student["avatar"] != nil
			 	 s.photo_url = student["avatar"]
			 	else
			 		s.photo_url = "/assets/placeholder.jpg"
			 	end
			  s.section = course
			  s.email = "#{student["email"]}"
			  s.blog = "#{student["blog"]}"
			  s.twitter = student["twitter"]
			  s.stream = []
			  if s.twitter != ''
				tweets = Twitter.user_timeline(student["twitter"])
					tweets.each do |tweet|
						text = tweet.attrs[:text]
						tweet_url = "http://www.twitter.com/#{s.twitter}/status/#{tweet.attrs[:id_str]}"
						s.stream.push [text, tweet_url]
					end
				end
				@students[course] << s
			end
		end
	end
end