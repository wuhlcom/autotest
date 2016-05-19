class Float
	def roundf(places)
		size = self.to_s.size
		sprintf("%#{size}.#{places}f", self).to_f
	end

	def roundn(nth)
		num           = self*(10**(-nth))
		num_float     = num.round*(10**nth).to_f
		num_float_str = num_float.to_s
		num_float_str =~/\.(\d*)/
		dot_num_size = Regexp.last_match(1).size
		if dot_num_size>nth.abs
			num_float = num_float_str[/\d+\.\d{#{nth.abs}}/]
		end
		return num_float.to_f
	end
end


# p 100.555.roundf(2)
# p 1123.555.round_n(-2)

 # p ((8-9).to_f.abs/3).roundf(2)
p ((1050624-1048576).to_f.abs/1050624)#.roundf(2)