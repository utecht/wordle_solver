#!/usr/bin/env ruby

fivers = Array.new
File.open('words_alpha.txt').each do | word |
	if word.strip.length == 5 then
		fivers.push word
	end
end

File.open('fivers.txt', 'w') do |f|
	fivers.each do |word|
		f.write(word)
	end
end
