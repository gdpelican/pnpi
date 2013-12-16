json.array!(@resources) do |resource|
  json.extract! resource, 
  json.url resource_url(resource, format: :json)
end
