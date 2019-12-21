#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


def init_db
	@db = SQLite3::Database.new('leprosorium.db')
	@db.results_as_hash = true
	return @db
end

# вызывается каждый раз после перезагрузки любой страницы

before do
	# инициализация базы данных
	
	init_db	
end

# вызывается каждый раз при конфигурации приложеия
# когда изменился код программы и перезагрузилась страница

configure do
	# инициализация базы данных
	
	init_db
	# создает таблицу если не существует
	
	@db.execute 'CREATE TABLE  IF NOT EXISTS 
	"Posts"
	(
		"id" INTEGER PRIMARY KEY AUTOINCREMENT,
		"created_date" DATE,
		"content" TEXT
	)'
end

get '/' do
	@result = @db.execute 'SELECT * FROM "Posts" ORDER BY ID DESC'
	erb :index	
end

# обработчик get запроса /new
# (браузер получает страницу с сервера)

get '/new' do
	erb :new
end

# обработчик post запроса /new
# (браузер отправляет данные на сервер)

post '/new' do
	# получаем переменную из POST запроса
	
	content = params[:content]
	if content.size <= 0
		@error = 'Type post text'
		return erb :new
	end
	
	# сохраненеие данных в БД	

	@db.execute 'INSERT INTO "Posts"(content, created_date) VALUES(?, datetime())', [content]
	erb redirect to '/'
end






