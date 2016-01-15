module ApplicationHelper

	# return full title for each page
	def full_title(page_title = '')
		# default title
		base_title = "Sample App"

		# If there is no title for the page, just use base_title
		if page_title.empty?
			base_title # return base_title
		else
			"#{page_title} | #{base_title}" # return concatenation of page+base titles
		end
	end
end
