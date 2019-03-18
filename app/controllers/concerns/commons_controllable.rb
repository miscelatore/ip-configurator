module CommonsControllable
  extend ActiveSupport::Concern
  
  def clear_search_index
    if params[:search_cancel]
      params.delete(:search_cancel)
      if(!search_params.nil?)
        search_params.each do |key, param|
          search_params[key] = nil
          session.delete(key)
        end
      end
    end
  end 
  
end