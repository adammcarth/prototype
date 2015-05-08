require "bundler"
Bundler.require

JTask.configure do |config|
  config.file_dir = "data/"
end

get "/" do
  @latest_requests = JTask.get("requests.json", {last: 3})
  @items = JTask.get("items.json", {last: 9})
  erb :index
end

get "/requests" do
  @requests = JTask.get("requests.json")
  erb :requests
end

get "/requests/new" do
  erb :new_request
end

post "/requests/new" do 
  JTask.save("requests.json", {
    title: params[:title],
    num_backers: 1
  })

  redirect "/requests"
end

get "/join/:id" do
  id = params[:id].to_i

  if params[:phase] == "alpha"
    JTask.update("requests.json", id, {
      num_backers: JTask.get("requests.json", id).num_backers + 1
    })
  else
    JTask.update("items.json", id, {
      num_backers: JTask.get("items.json", id).num_backers + 1
    })
  end

  redirect "/"
end