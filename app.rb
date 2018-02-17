require 'sinatra/base'

class ScoutingProject < Sinatra::Base
get '/' do
  erb :index
end

helpers do
  def partial(template, *args)
    options = args.extract_options!
    options.merge!(:layout => false)
    if collection = options.delete(:collection) then
      collection.inject([]) do |buffer, member|
        buffer << erb(template, options.merge(
                                  :layout => false,
                                  :locals => {template.to_sym => member}
                                )
                     )
      end.join("\n")
    else
      erb(template, options)
    end
  end
end
end


