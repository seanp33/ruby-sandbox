require 'mongo'

class Storage

  attr_reader :db, :conn

  def initialize(server, port, dbname)
    @server = server
    @port   = port
    @dbname = dbname
  end

  def connect
    @conn = Mongo::Connection.new(@svr, @port)
    @db   = @conn.db(@dbname)
  end

  def disconnect
    @conn.close
  end

  def connected?
    @conn.connected?
  end

  def collection(name)
    @db.collection name
  end

  def to_s
    "#{@server}/#{@port}/#{@dbname}"
  end

end
