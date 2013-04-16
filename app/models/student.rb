class Student
  attr_accessor :name, :photo_url, :section, :twitter, :stream, :email, :blog
 


  def print_stream
  	self.stream.each do |tweet|
  		puts "<a href='#{tweet[1]}' target='_blank'><p>#{tweet[0]}</p></a>"
  	end

  end
end