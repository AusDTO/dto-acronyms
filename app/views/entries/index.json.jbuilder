json.entries entries do |entry|
  json.term entry.term
  json.expanded_term entry.expanded_term
  json.definition entry.definition
  json.url entry_url(entry)
end
