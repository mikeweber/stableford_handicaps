class InitImport
  def self.import_file(file)
    import_unsorted(file.read.split("\n"))
  end

  def self.import_unsorted(lines)
    (lines.length / 11).times do |i|
      starting_line = i * 11
      splits = lines[starting_line].split('|')
      player_data = []
      (splits.size / 2).times { |i| player_data << splits[(i * 2)..(i * 2 + 1)] }
      golfers = player_data.map do |data|
        last_name, first_name = data[0].split(',')
        golfer = Golfer.create!(last_name: last_name.to_s.strip, first_name: first_name.to_s.strip, handicap: data[1], identifier: '0')
        puts "Created #{golfer.full_name}"
        HandicapCalculator.new(golfer)
      end
      10.times do |j|
        potential_scores = lines[starting_line + j + 1].split('|')
        potential_scores.each.with_index do |scores, index|
          days, score = scores.split(/ +/)
          puts "Posting score #{golfers[index].golfer.full_name} - #{score} #{10 - days.to_i} days ago"
          golfers[index].post_score(score, (20 - days.to_i).days.ago)
        end
      end
    end
  end
end
