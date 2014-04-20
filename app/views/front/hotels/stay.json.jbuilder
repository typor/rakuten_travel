json.array! @results do |v|
  if v[1][:min] == v[1][:max]
    json.title number_with_delimiter(v[1][:min])
  else
    json.title number_with_delimiter(v[1][:min]) + ' - ' + number_with_delimiter(v[1][:max])
  end
  json.start v[1][:start]
  json.url v[1][:url]
end