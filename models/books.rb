require_relative( '../db/sql_runner' )

class Book

  attr_reader(:id)
  attr_accessor(:title, :genre, :cost_price, :selling_price, :stock_level, :stock_condition,  :publisher_id)

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @genre = options['genre']
    @cost_price = options['cost_price'].to_f
    @selling_price = options['selling_price'].to_f
    @stock_level = options['stock_level'].to_i
    @stock_condition = options['stock_condition']
    @publisher_id = options['publisher_id'].to_i
  end

  #CREATE
  def save()
    sql = "INSERT INTO books
    (
      title,
      genre,
      cost_price,
      selling_price,
      stock_level,
      publisher_id
    )
    VALUES
    (
      $1, $2, $3, $4, $5, $6
    )
    RETURNING id"
    values = [@title, @genre, @cost_price, @selling_price, @stock_level, @publisher_id]
    results = SqlRunner.run(sql, values)
    @id = results.first()['id'].to_i
  end

  #FIND ALL
  def self.all()
    sql = "SELECT * FROM books"
    results = SqlRunner.run(sql)
    return results.map {|book| Book.new(book)}
  end

  #FIND ONE LINE
  def self.find_by_id(id)
    sql = "SELECT * FROM books
    WHERE id = $1"
    values = [id]
    results = SqlRunner.run(sql, values)
    return Book.new(results.first)
  end

  #DELETE ALL
  def self.delete_all
    sql = "DELETE FROM books"
    SqlRunner.run(sql)
  end
  
  #DELETE ONE LINE
  def self.delete_by_id(id)
    sql = "DELETE FROM books WHERE id = $1"
    values = [id]
    SqlRunner.run(sql,values)
  end

  #UPDATE
  def update_by_id()
    sql = "UPDATE books SET (cost_price, selling_price, stock_level) = ($1, $2, $3) WHERE id= $4"
    values = [@cost_price, @selling_price, @stock_level, @id]
    SqlRunner.run(sql,values)
  end

  #CHECK STOCK CONDITION
  def check_stock_condition()
    if @stock_level == 0
      stock_condition = "Out Of Stock"
    elsif @stock_level <= 3
      stock_condition = "Low Stock"
    else
      stock_condition = "In Stock"
    end
    @stock_condition = stock_condition
    return @stock_condition
  end

  #CALCULATE MARKUP
  def calc_markup()
    markup = @selling_price - @cost_price
    return markup.round(2)
  end

end
