class PlaceDecorator < ResourceDecorator
  delegate_all
  
  def details
    [{ text: address, icon: 'globe', link: "http://www.google.com/maps/preview#!q=#{address.gsub(' ', '+') if address}+Philadelphia+PA" }]
  end
end
