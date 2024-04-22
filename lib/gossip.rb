require 'csv'

class Gossip
  attr_accessor  :content, :id, :author

  @id = 0

  def initialize(id, author, content)
    @id = id
    @author = author
    @content = content
  end

  def save
    FileUtils.mkdir_p('db') unless File.directory?('db')
    csv_path = "db/gossip.csv"
    @id = next_id(csv_path) if @id.nil?
    CSV.open(csv_path, "ab") do |csv|
      csv << [@id, @author, @content]
    end
  end

  def self.all
    all_gossips = []
    CSV.foreach("./db/gossip.csv") do |row|
      all_gossips << Gossip.new(row[0].to_i, row[1], row[2])
    end
    all_gossips
   end
   
  def self.find(id)
    all_gossips = self.all
    all_gossips.find { |gossip| gossip.id.to_i == id.to_i }
  end

  def update(new_author, new_content)
    @author = new_author
    @content = new_content
    save
  end

  private

    def next_id(csv_path)
      if File.exist?(csv_path) && !CSV.read(csv_path).empty?
        last_id = CSV.read(csv_path).map { |row| row[0].to_i }.max
        last_id + 1
      else
        1
      end
    end

  end
    




