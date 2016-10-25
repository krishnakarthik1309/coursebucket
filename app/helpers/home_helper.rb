module HomeHelper
	MOOCS = {"coursera", "udacity"}

	def add_courses_to_db(course_site, connection)
	  	i = 0
	    nxt = 1
	    while nxt > 0 do
	    	course_url = get_url(course_site, i)
		  	course_uri = URI(course_url)
		  	course_response = Net::HTTP.get(course_uri)
		  	course_json = JSON.parse(course_response)
		  	course_courses = get_courses(course_json)
		  	
		  	# add each course to db
		  	for course in course_courses
			  	id = get_id(course)
			  	name = get_name(course)
			  	slug = get_slug(course)
			  	connection.addUser(id, name, slug, course_site)
		  	end

		  	i += 25
		  	if course_site == "coursera"
		  		nxt = course_json["next"]
		  	else
		  		nxt = 0
		  	end
	    end
  	end

	def get_courses(json_data)
		if json_data.key?(:elements)
			return json_data["elements"]
		elsif json_data.key?(:courses)
			return json_data["courses"]
		end

	def get_url(course_site, index)
		if course_site == "coursera"
			return "https://api.coursera.org/api/courses.v1?start=#{index}&limit=25"
		elsif course_site == "udacity"
			return "https://www.udacity.com/public-api/v0/courses"
		end
	end

	def get_id(dicti)
		if dicti.key?(:id)
			return dicti["id"]
		elsif dicti.key?(:key)
			return dicti["key"]
		else
			return "No id"
		end
	end

	def get_name(dicti)
		if dicti.key?(:name)
			return dicti["name"]
		elsif dicti.key?(:title)
			return dicti["title"]
		else
			return "No name"
		end
	end

	def get_slug(dicti)
		if dicti.key?(:slug)
			return dicti("slug")
		else
			return "No slug"
		end
	end
end
