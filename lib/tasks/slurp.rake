namespace :slurp do
  desc "TODO"
  task playerstats: :environment do
    require "csv"
    csv_text = File.read(Rails.root.join("lib", "csvs", "ffa_norm2.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
      p = Player.new
      p.name = row['name']
      p.team = row['team']
      p.position = row['position']
      p.bye = row['bye'].to_i
      p.points = row['points'].to_f
      p.vor = row['vor'].to_f
      p.overall_rank = row['overallRank'].to_i
      p.position_rank = row['positionRank'].to_i
      p.adp = row['adp'].to_f
      p.save
    end
    
    puts "There are now #{Player.count} rows in the transactions table"
  end

end
