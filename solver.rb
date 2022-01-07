#!/usr/bin/env ruby

class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end
end


class Clue
	attr_accessor :letter, :status, :positions

	def initialize(letter, status, positions)
		@letter = letter
		@status = status
		@positions = positions
	end

	def to_green(pos)
		@status = :green
		@positions = [pos]
	end

	def to_s
		case @status
		when :green
			return "#{@letter}".green
		when :yellow
			return "#{@letter}".yellow
		when :grey
			return "#{@letter}"
		end
	end
end

def valid?(word, clues)
	clues.each do |clue|
		case clue.status
		when :green
			clue.positions.each do |pos|
				return false unless word[pos] == clue.letter
			end
		when :yellow
			return false unless word.include? clue.letter
			clue.positions.each do |pos|
				return false if word[pos] == clue.letter
			end
		when :grey
			return false if word.include? clue.letter
		end
	end
	true
end

fivers = Array.new
File.open('fivers.txt').each do | word |
	fivers.push word.strip
end

clues = []

i = 0
while true
	print "#{i}: "
	letters = gets.chomp
	letter, status_letter = letters.split
	if letter != '.'
		status = :grey
		status = :green if status_letter == 'g'
		status = :yellow if status_letter == 'y'

		added = false
		clues.each do |clue|
			if clue.letter == letter
				added = true
				if status == :green
					clue.to_green i
				end
				if status == :yellow
					clue.positions.push i unless clue.positions.include? i
				end
			end
		end
		unless added
			clues.push Clue.new(letter, status, [i])
		end
	end
	i += 1
	if i == 5
		puts clues.join('|')
		good_words = fivers.select { |word| valid?(word, clues) }
		puts good_words.length
		puts good_words.sample(20)
		i = 0
	end
end
