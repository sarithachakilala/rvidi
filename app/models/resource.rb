class Resource < ActiveRecord::Base

  attr_accessible :http_method, :url, :description,:name,
            :api_id

 
  belongs_to :api

  has_many :parameters

  def self.http_methods
    ["GET", "PUT", "POST", "DELETE"]
  end


  def url_representation
    http_method + "&nbsp;&nbsp;" + url
  end

  def authentication?
     authentication_required ? "Yes" : "No"
  end

  def base_url
    "http://" + "rvidi.qwinixtech.com"
  end

  def full_url
    base_url + "/" + url
  end

  def example_request
    query_string = parameters.collect{|parameter|
      "#{parameter.name}=#{parameter.example_values}" unless url.match(":#{parameter.name.gsub('[', '\[').gsub(']', '\]')}")
    }.compact.join("&")
    str = http_method + " " + base_url + "/" + url
    str+= "?" + query_string unless query_string.blank?
    str
  end
end