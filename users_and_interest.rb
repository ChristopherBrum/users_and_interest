require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"
require 'yaml'

before do 
  @users = YAML.load_file("data/users.yaml")
  @num_of_users = @users.size

  @users.each_with_index { |user, id| user.last[:id] = id }
end

helpers do
  def assign_param_id(user)
    params[:id] = user.last[:id]
  end

  def update_param_id(user_info)
    params[:id] = user_info[:id]
  end

  def find_user
    @users.select do |name, info|
      info[:id] == params[:id].to_i
    end
  end

  def find_user_name
    user = find_user
    user.first[0].capitalize
  end

  def find_other_users
    @users.select do |name, info|
      info[:id] != params[:id].to_i
    end
  end

  def count_interests
    @users.map do |user|
      user.last[:interests].size
    end.sum
  end
end

not_found do
  redirect "/"  
end

get '/' do
  redirect "/users"
end

get "/users" do
  @arr = ['Hello', 'Goodbye', 'Stop']
  erb :users
end

get "/users/:id" do
  erb :user
end
