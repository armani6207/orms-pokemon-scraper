require 'pry'
class Pokemon
    attr_accessor :name, :type, :id
    attr_reader :db

    def initialize(id: nil, name:, type:, db:)
        @id = id
        @name = name
        @type = type
        @db = db
    end

    def self.save(name, type, db)
        poke = self.new(name: name, type: type, db: db)
        sql = <<-SQL
        INSERT INTO pokemon (name, type) VALUES
        (?, ?)
        SQL
        db.execute(sql, poke.name, poke.type)
        poke.id=(db.execute("SELECT last_insert_rowid()")[0][0]) 
    end

    def self.find(id, db)
        sql = <<-SQL
        SELECT *
        FROM pokemon
        WHERE id = ?
        SQL
        match = db.execute(sql, id).pop
        self.new(id: match[0], name: match[1], type: match[2], db: db)
    end

end
