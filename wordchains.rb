require "set"

# A Wordchain is initialized with a dictionary. It takes in two words as inputs,
# and by only making one letter change at a time, attempts to find a path
# through the valid words of the dictionary between the two inputs. It outputs
# this information as an array within the console, or provides a failed message.

class WordChains
  ALPHABET = [*?a..?z]

  def self.parse_from_file(file)
    dictionary = File.readlines(file).map(&:chomp)
    WordChains.new(dictionary)
  end

  def initialize(dictionary)
    @all_seen_words = Hash.new { |h,k| h[k] = nil }
    @dictionary = Set.new dictionary
  end

  def adjacent_words(word)
    word_bucket = []
    word.length.times do |idx|
      ALPHABET.each do |letter|
        search = word[0...idx] + letter + word[idx.next..-1]
        word_bucket << search if @dictionary.include? search
      end
    end
    word_bucket
  end

  def run(source, target)
    @current_words = [source]
    until @current_words.empty? || @all_seen_words.include?(target)
      @current_words = explore_current_words
    end
    if @all_seen_words.key?(target)
      p build_path(target)
    else
      puts "Not Found"
    end
  end

  def explore_current_words
    new_current_words = []
    @current_words.each do |current_word|
      adjacent_words(current_word).each do |wrd|
        unless @all_seen_words.include? wrd
          @all_seen_words[wrd] = current_word
          new_current_words << wrd
        end
      end
    end
    new_current_words
  end

  def build_path(target)
    pathing_history = [target]
    if @all_seen_words[target]
      value = build_path(@all_seen_words[target])
      pathing_history += value
    end
    pathing_history
  end

end

test = WordChains.parse_from_file './dictionary.txt'
test.run('trees','treat')
